import 'dart:convert';
import 'package:crypto/crypto.dart'; // For SHA-256 hashing
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tech_rev/screens/dashboard_page.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> registerUser(String accountType) async {
    if (!_formKey.currentState!.validate()) {
      print('Validation failed');
      return; // Stop execution if validation fails
    }

    final fullName = _fullNameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    print('Full Name: ${_fullNameController.text}');
    print('Username: ${_usernameController.text}');
    print('Password: ${_passwordController.text}');

    // Hash the password using SHA-256
    final bytes = utf8.encode(password); // Convert password to bytes
    final hashedPassword = sha256.convert(bytes).toString(); // Hash the bytes

    try {
      final tableName = accountType.toLowerCase() == 'student' ? 'students' : 'teachers';
      print('Inserting into table: $tableName');
      print('Hashed Password: $hashedPassword');

      // Insert into Supabase
      final response = await Supabase.instance.client
          .from(tableName)
          .insert({
        'full_name': fullName,
        'username': username,
        'password': hashedPassword, // Store the hashed password
      })
          .select();

      print('Insert successful: $response'); // Debug the response
      if (response != null && response.isNotEmpty) {
        // Save session key
        final sessionKey = "teacher_${DateTime.now().millisecondsSinceEpoch}";
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_key', sessionKey);
        await prefs.setString('username', username);
        await prefs.setString('account', accountType.toLowerCase());
        // Show success SnackBar
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful as $accountType!'),
          ),
        );


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage(username: username, account: accountType.toLowerCase()),
          )
        );
      } else {
        throw Exception('No response returned from Supabase.');
      }
    } catch (e) {
      print('Supabase error: $e');

      // Ensure the SnackBar is in front
      ScaffoldMessenger.of(context).clearSnackBars();
      if (e is PostgrestException && e.code == '23505') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Username "$username" is already registered.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
      Navigator.pop(context);
    }
  }

  void showRegistrationForm(BuildContext context, String accountType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Register as $accountType',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Read-only Account Type Field
                  TextFormField(
                    readOnly: true,
                    initialValue: accountType,
                    decoration: InputDecoration(
                      labelText: 'Account Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Full Name Field
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your full name' : null,
                  ),
                  SizedBox(height: 20),
                  // Username Field
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.account_circle),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a username' : null,
                  ),
                  SizedBox(height: 20),
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) =>
                    value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                  ),
                  SizedBox(height: 30),
                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      registerUser(accountType);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF6FE), Color(0xFFC8E4FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'What type of account would you like to create?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            // Account Type Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Student Button
                GestureDetector(
                  onTap: () => showRegistrationForm(context, 'Student'),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Student',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // Teacher Button
                GestureDetector(
                  onTap: () => showRegistrationForm(context, 'Teacher'),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Teacher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Already Have an Account? Login
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text(
                'Already have an account? Login',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
