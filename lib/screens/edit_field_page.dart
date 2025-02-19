import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
class EditFieldPage extends StatelessWidget {
  final String title;
  final String fieldName;
  final String initialValue;
  final String account;
  final String student_id;
  final String teacher_id;

  const EditFieldPage({
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
      try {
        // Validate input: Only letters and spaces allowed
        final inputValue = controller.text.trim();
        final validInput = RegExp(r'^[a-zA-Z\s]+$');

        if (inputValue.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: You cannot leave this field empty.')),
          );
          return;
        }

        if (!validInput.hasMatch(inputValue)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: Only letters and spaces are allowed.')),
          );
          return;
        }

        // Determine the table and ID field
        final tableName = account.toLowerCase() == 'teacher' ? 'teachers' : 'students';
        final idField = account.toLowerCase() == 'teacher' ? 'teacher_id' : 'student_id';
        final idValue = account.toLowerCase() == 'teacher' ? teacher_id : student_id;

        print('Table Name: $tableName');
        print('ID Field: $idField');
        print('ID Value: $idValue');

        // Perform the update and request updated rows
        final response = await Supabase.instance.client
            .from(tableName)
            .update({fieldName: inputValue})
            .eq(idField, idValue)
            .select(); // Ensures the updated rows are returned

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
          Navigator.pop(context, inputValue);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update $fieldName.')),
          );
          print('Failed to update');
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
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Enter new $fieldName',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'you cannot leave this empty';
                }
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return 'you can only input letters and spaces';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateField();
              },
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
