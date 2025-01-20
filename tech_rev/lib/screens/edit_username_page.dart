import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
class EditUsernamePage extends StatelessWidget {
  final String title;
  final String fieldName;
  final String initialValue;
  final String account;
  final String student_id;
  final String teacher_id;

  const EditUsernamePage({
    super.key,
    required this.title,
    required this.fieldName,
    required this.initialValue,
    required this.account,
    required this.student_id,
    required this.teacher_id,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: initialValue);

    Future<void> updateField() async {
      final newValue = controller.text.trim();

      if (newValue.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$fieldName cannot be empty.')),
        );
        return;
      }

      try {
        // Determine the table and ID field
        final tableName = account.toLowerCase() == 'teacher' ? 'teachers' : 'students';
        final idField = account.toLowerCase() == 'teacher' ? 'teacher_id' : 'student_id';
        final idValue = account.toLowerCase() == 'teacher' ? teacher_id : student_id;

        // Check if the new username already exists in the table
        final existingUserResponse = await Supabase.instance.client
            .from(tableName)
            .select()
            .eq('username', newValue)
            .maybeSingle();

        if (existingUserResponse != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: Username "$newValue" is already taken.')),
          );
          return;
        }

        // Perform the update
        final response = await Supabase.instance.client
            .from(tableName)
            .update({fieldName: newValue})
            .eq(idField, idValue)
            .select();

        if (response != null && response.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          final updatedData = response.first; // Assuming response contains updated row

          // Update individual fields in SharedPreferences
          if (updatedData.containsKey(fieldName)) {
            await prefs.setString(fieldName, updatedData[fieldName]);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$fieldName updated successfully!')),
          );
          Navigator.pop(context, newValue);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update $fieldName.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF3A86FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Enter new $fieldName',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateField,
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