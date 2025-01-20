import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SectionsPage extends StatefulWidget {
  final String teacherId; // Passed from the dashboard

  const SectionsPage({super.key, required this.teacherId});

  @override
  State<SectionsPage> createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  List<dynamic> sections = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSections();
  }

  Future<void> _fetchSections() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('sections')
          .select()
          .eq('teacher_id', widget.teacherId);

      setState(() {
        sections = response ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching sections: $e')),
      );
    }
  }

  Future<void> _fetchStudents(String sectionName) async {
    final studentsController = showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FutureBuilder(
          future: Supabase.instance.client
              .from('students')
              .select()
              .eq('section_name', sectionName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'No students yet',
                    style: TextStyle(fontSize: 16, color: Colors.redAccent),
                  ),
                ),
              );
            }

            final students = snapshot.data ?? [];

            if (students.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'No students yet.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return ListTile(
                    title: Text(student['full_name']),
                    subtitle: Text('Student ID: ${student['student_id']}'),
                  );
                },
              ),
            );
          },
        );
      },
    );

    await studentsController;
  }

  Future<void> _addSection(String sectionName) async {
    try {
      await Supabase.instance.client.from('sections').insert({
        'section_name': sectionName,
        'teacher_id': widget.teacherId,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Section added successfully!')),
      );
      _fetchSections(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding section: $e')),
      );
    }
  }

  void _showAddSectionDialog() {
    final TextEditingController sectionController = TextEditingController();

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New Section',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: sectionController,
                decoration: InputDecoration(
                  labelText: 'Section Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the overlay
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (sectionController.text.trim().isNotEmpty) {
                        _addSection(sectionController.text.trim());
                        Navigator.pop(context); // Close the overlay
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Section name cannot be empty')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3A86FF),
                    ),
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sections'),
        backgroundColor: const Color(0xFF3A86FF),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : sections.isEmpty
          ? Center(
        child: Text(
          'No added sections yet.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      )
          : ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return ListTile(
            title: Text(
              section['section_name'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('ID: ${section['section_id']}'),
            onTap: () => _fetchStudents(section['section_name']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSectionDialog,
        backgroundColor: const Color(0xFF3A86FF),
        child: Icon(Icons.add),
      ),
    );
  }
}
