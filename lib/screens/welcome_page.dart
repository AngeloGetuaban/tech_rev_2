import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_page.dart'; // Import the DashboardPage class
import 'login_page.dart'; // Import the LoginPage class

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionKey = prefs.getString('session_key');
    final username = prefs.getString('username');
    final account = prefs.getString('account');

    if (sessionKey != null && username != null) {
      // Navigate to DashboardPage if a session exists
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage(username: username, account: account!)),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Section
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'), // Replace with your logo asset
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Subtitle Section
            Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins', // Custom modern font
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            // Title Section
            Text(
              'TECH REV',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins', // Custom modern font
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            // Get Started Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                backgroundColor: Color(0xFF3A86FF), // Button background color
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins', // Custom modern font
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
