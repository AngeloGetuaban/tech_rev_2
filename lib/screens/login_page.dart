import 'dart:convert';
import 'package:crypto/crypto.dart'; // For SHA-256 hashing
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tech_rev/screens/dashboard_page.dart';
import 'package:tech_rev/screens/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> loginUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password.')),
      );
      return;
    }

    // Hash the password using SHA-256
    final bytes = utf8.encode(password); // Convert password to bytes
    final hashedPassword = sha256.convert(bytes).toString(); // Hash the bytes

    try {
      // Check in students table
      final studentResponse = await Supabase.instance.client
          .from('students')
          .select()
          .eq('username', username)
          .eq('password', hashedPassword);

      if (studentResponse.isNotEmpty) {
        final sessionKey = "student_${DateTime.now().millisecondsSinceEpoch}";
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_key', sessionKey);
        await prefs.setString('username', username);
        await prefs.setString('account', 'student');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful as Student!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardPage(username: username, account: 'student'),
          ),
        );
        return;
      }

      // Check in teachers table
      final teacherResponse = await Supabase.instance.client
          .from('teachers')
          .select()
          .eq('username', username)
          .eq('password', hashedPassword);

      if (teacherResponse.isNotEmpty) {
        final sessionKey = "teacher_${DateTime.now().millisecondsSinceEpoch}";
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_key', sessionKey);
        await prefs.setString('username', username);
        await prefs.setString('account', 'teacher');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful as Teacher!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardPage(username: username, account: 'teacher'),
          ),
        );
        return;
      }

      // If no matches found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                // Logo Section
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'), // Replace with your logo asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'TECHREV',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                // Login Title
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 30),
                // Username TextField
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 20),
                // Password TextField
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
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
                    if (!RegExp(r'^(?=.*[0-9])(?=.*[!@#\$%^&*])[A-Za-z\d!@#\$%^&*]{8,16}$')
                        .hasMatch(value)) {
                      return 'Password must be 8-16 characters long and include at least one number and one special character';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                // Login Button
                ElevatedButton(
                  onPressed: loginUser,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Register Now Button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationPage()),
                    );
                  },
                  child: Text(
                    'Don\'t have an account yet? Register Now',
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
        ),
      ),
    );
  }
}
