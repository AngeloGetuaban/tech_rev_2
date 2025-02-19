import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditSectionPage extends StatefulWidget {
  final String student;

  const EditSectionPage({super.key, required this.student});

  @override
  State<EditSectionPage> createState() => _EditSectionPageState();
}

class _EditSectionPageState extends State<EditSectionPage> {
  final TextEditingController _sectionController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSection();
  }

  Future<void> _fetchSection() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('students')
          .select('section_name')
          .eq('student_id', widget.student)
          .single();

      if (response != null && response['section_name'] != null) {
        _sectionController.text = response['section_name'];
      } else {
        _sectionController.text = ''; // Pass empty if null
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching section: $e')),
      );
    }
  }

  Future<void> _updateSection() async {
    try {
      await Supabase.instance.client
          .from('students')
          .update({'section_name': _sectionController.text.trim()})
          .eq('student_id', widget.student);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Section updated successfully!')),
      );

      Navigator.pop(context); // Close the page after updating
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating section: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Section'),
        backgroundColor: const Color(0xFF3A86FF),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _sectionController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Section Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
