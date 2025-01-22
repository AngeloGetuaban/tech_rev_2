import 'dart:convert';
import 'package:crypto/crypto.dart'; // For SHA-256 hashing
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tech_rev/screens/dashboard_page.dart';
import 'package:tech_rev/screens/registration_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();

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

        if (studentResponse != null && studentResponse.isNotEmpty) {
          // Create session key and save it to SharedPreferences
          final sessionKey = "student_${DateTime.now().millisecondsSinceEpoch}";
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('session_key', sessionKey);
          await prefs.setString('username', username);
          await prefs.setString('account', 'student');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful as Student!')),
          );

          // Navigate to the home page or next screen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage(username: username, account: 'student',)));
          return;
        }

        // Check in teachers table
        final teacherResponse = await Supabase.instance.client
            .from('teachers')
            .select()
            .eq('username', username)
            .eq('password', hashedPassword);

        if (teacherResponse != null && teacherResponse.isNotEmpty) {
          // Create session key and save it to SharedPreferences
          final sessionKey = "teacher_${DateTime.now().millisecondsSinceEpoch}";
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('session_key', sessionKey);
          await prefs.setString('username', username);
          await prefs.setString('account', 'teacher');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful as Teacher!')),
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage(username: username, account: 'teacher',)));
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50), // Add spacing at the top
                // Logo Section
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'), // Keep the logo
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // App Name
                Text(
                  'TECH REV',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins', // Custom modern font
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                // Login Title
                Text(
                  'Login to Your Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins', // Custom modern font
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 30),
                // Username TextField
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 20),
                // Password TextField
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 30),
                // Login Button
                SizedBox(
                  width: double.infinity, // Make the button take full width
                  child: ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.white, // Button background color
                      shadowColor: Colors.black.withOpacity(0.2),
                      elevation: 5,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins', // Custom modern font
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Already Have an Account? Login
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50), // Add spacing at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}