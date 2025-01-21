import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPasswordPage extends StatelessWidget {
  final String student_id;
  final String teacher_id;
  final String account;

  const EditPasswordPage({
    super.key,
    required this.student_id,
    required this.teacher_id,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    Future<void> updatePassword() async {
      if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields.')),
        );
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match.')),
        );
        return;
      }

      try {
        // Hash the new password using SHA-256
        final newPassword = passwordController.text.trim();
        final hashedPassword = sha256.convert(utf8.encode(newPassword)).toString();

        // Determine the table and ID field
        final tableName = account.toLowerCase() == 'teacher' ? 'teachers' : 'students';
        final idField = account.toLowerCase() == 'teacher' ? 'teacher_id' : 'student_id';
        final idValue = account.toLowerCase() == 'teacher' ? teacher_id : student_id;

        // Perform the update in the respective table
        final response = await Supabase.instance.client
            .from(tableName)
            .update({'password': hashedPassword}) // Update the password field
            .eq(idField, idValue)
            .select(); // Ensure updated rows are returned

        if (response != null && response.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password updated successfully!')),
          );
          Navigator.pop(context);
        } else {
          throw Exception('Failed to update the password.');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        print('Error updating password: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password'),
        backgroundColor: const Color(0xFF3A86FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3A86FF),
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
