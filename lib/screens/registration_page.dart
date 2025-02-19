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
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false; // Toggle password visibility

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          child: RegistrationForm(accountType: accountType),
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

class RegistrationForm extends StatefulWidget {
  final String accountType;

  const RegistrationForm({super.key, required this.accountType});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  bool _isPasswordVisible = false; // This now properly updates

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) {
      print('Validation failed');
      return; // Stop execution if validation fails
    }

    final firstName = _firstNameController.text.trim();
    final middleName = _middleNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // **Validation for Name Fields**
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(firstName) || !nameRegex.hasMatch(lastName) ||
        (middleName.isNotEmpty && !nameRegex.hasMatch(middleName))) {
      showOverlayWarning('Error: Names should only contain letters and spaces.');
      return;
    }

    // **Validation for Password**
    final passwordRegex = RegExp(r'^(?=.*[0-9])(?=.*[!@#\$%^&*])[A-Za-z\d!@#\$%^&*]{8,16}$');
    if (!passwordRegex.hasMatch(password)) {
      showOverlayWarning('Error: Password must be 8-16 characters long and include at least one number and one special character.');
      return;
    }

    print('First Name: $firstName');
    print('Middle Name: $middleName');
    print('Last Name: $lastName');
    print('Username: $username');
    print('Password: $password');

    // **Hash the password using SHA-256**
    final bytes = utf8.encode(password);
    final hashedPassword = sha256.convert(bytes).toString();

    try {
      final tableName = widget.accountType.toLowerCase() == 'student' ? 'students' : 'teachers';
      print('Inserting into table: $tableName');
      print('Hashed Password: $hashedPassword');

      // **Insert into Supabase**
      final response = await Supabase.instance.client
          .from(tableName)
          .insert({
        'first_name': firstName,
        'middle_name': middleName.isNotEmpty ? middleName : null,
        'last_name': lastName,
        'username': username,
        'password': hashedPassword,
      }).select();

      print('Insert successful: $response');

      if (response != null && response.isNotEmpty) {
        final sessionKey = "${widget.accountType.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}";
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_key', sessionKey);
        await prefs.setString('username', username);
        await prefs.setString('account', widget.accountType.toLowerCase());

        showOverlayWarning('Registration successful as ${widget.accountType}!');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(username: username, account: widget.accountType.toLowerCase()),
          ),
              (Route<dynamic> route) => false, // This removes all previous routes
        );
      } else {
        throw Exception('No response returned from Supabase.');
      }
    } catch (e) {
      print('Supabase error: $e');

      if (e is PostgrestException && e.code == '23505') {
        showOverlayWarning('Error: Username "$username" is already registered.');
      } else {
        showOverlayWarning('Error: $e');
      }
      Navigator.pop(context);
    }
  }

  void showOverlayWarning(String message) {
    late OverlayEntry overlayEntry; // Use late to ensure it is assigned before use

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05, // Show near the top
            left: MediaQuery.of(context).size.width * 0.1, // Center it
            right: MediaQuery.of(context).size.width * 0.1,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => overlayEntry.remove(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Auto-dismiss after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Register as ${widget.accountType}',
                style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(height: 20),
            // First Name Field
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return 'First name can only contain letters and spaces';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            // Middle Name Field (Optional)
            TextFormField(
              controller: _middleNameController,
              decoration: InputDecoration(
                labelText: 'Middle Name (Optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                // Allow empty values (optional field)
                if (value != null && value.isNotEmpty) {
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Middle name can only contain letters and spaces';
                  }
                }
                return null; // No error if empty or valid
              },
            ),
            SizedBox(height: 20),
            // Last Name Field
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return 'Last name can only contain letters and spaces';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            // Username Field
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.account_circle),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                // Optional: enforce a specific pattern for username (alphanumeric with underscores)
                if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                  return 'Username can only contain letters, numbers, and underscores';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            // Password Field with Visibility Toggle
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons
                      .visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                // Regex: 8-16 characters, at least one number and one special character.
                if (!RegExp(
                    r'^(?=.*[0-9])(?=.*[!@#\$%^&*])[A-Za-z\d!@#\$%^&*]{8,16}$')
                    .hasMatch(value)) {
                  return 'Password must be 8-16 characters long and include at least one number and one special character';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'Poppins', color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}