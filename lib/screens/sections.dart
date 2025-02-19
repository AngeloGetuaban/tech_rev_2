import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SectionsPage extends StatefulWidget {
  final String teacherId;

  const SectionsPage({super.key, required this.teacherId});

  @override
  State<SectionsPage> createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  List<dynamic> sections = [];
  Map<String, List<dynamic>> sectionStudents = {};
  Set<String> expandedSections = {}; // Keeps track of expanded sections
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

  Future<void> _fetchStudentsForSection(String sectionName) async {
    if (sectionStudents.containsKey(sectionName)) {
      setState(() {
        expandedSections.remove(sectionName);
        sectionStudents.remove(sectionName);
      });
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('students')
          .select()
          .eq('section_name', sectionName);

      setState(() {
        expandedSections.add(sectionName);
        sectionStudents[sectionName] = response ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching students: $e')),
      );
    }
  }

  Future<void> _showAddStudentDialog(String sectionName) {
    String? selectedStudent;
    List<dynamic> students = [];

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Assign Student to $sectionName',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 20),
                  FutureBuilder<List<dynamic>>(
                    future: Supabase.instance.client
                        .from('students')
                        .select()
                        .or("section_name.is.null,section_name.eq.''"),
                    // Fetch only unassigned students
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError || snapshot.data == null) {
                        return Text(
                          'Error fetching students',
                          style: TextStyle(color: Colors.red),
                        );
                      }

                      students = snapshot.data!;
                      if (students.isEmpty) {
                        return Text(
                          'No unassigned students available',
                          style: TextStyle(color: Colors.black54),
                        );
                      }

                      return DropdownButtonFormField<String>(
                        value: selectedStudent,
                        decoration: InputDecoration(
                          labelText: 'Select Student',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: students.map<DropdownMenuItem<String>>((
                            student) {
                          return DropdownMenuItem<String>(
                            value: student['student_id'].toString(),
                            child: Text(
                                '${student['first_name']} ${student['last_name']}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStudent = value;
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: Text('Close'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedStudent != null) {
                            await _assignStudentToSection(
                                selectedStudent!, sectionName);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Please select a student')),
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
      },
    );
  }


  Future<void> _assignStudentToSection(String studentId,
      String sectionName) async {
    try {
      await Supabase.instance.client
          .from('students')
          .update({'section_name': sectionName})
          .eq('student_id', studentId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Student assigned to $sectionName successfully!')),
      );
      _fetchSections();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning student: $e')),
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
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New Room',
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
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (sectionController.text
                          .trim()
                          .isNotEmpty) {
                        _addSection(sectionController.text.trim());
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              'Section name cannot be empty')),
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

  Future<void> _addSection(String sectionName) async {
    try {
      await Supabase.instance.client.from('sections').insert({
        'section_name': sectionName,
        'teacher_id': widget.teacherId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Section added successfully!')),
      );
      _fetchSections();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding section: $e')),
      );
    }
  }

  Future<void> _removeStudentFromSection(String studentId) async {
    try {
      await Supabase.instance.client
          .from('students')
          .update({'section_name': null}) // Set section_name to NULL
          .eq('student_id', studentId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student removed from section successfully!')),
      );

      _fetchSections(); // Refresh sections
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing student: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students and Rooms'),
        backgroundColor: const Color(0xFF3A86FF),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          final sectionName = section['section_name'];
          final students = sectionStudents[sectionName] ?? [];

          return Column(
            children: [
              ListTile(
                title: Text(
                  sectionName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      mini: true,
                      onPressed: () => _showAddStudentDialog(sectionName),
                      child: Icon(Icons.person_add),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        expandedSections.contains(sectionName)
                            ? Icons.expand_less
                            : Icons.expand_more,
                      ),
                      onPressed: () => _fetchStudentsForSection(sectionName),
                    ),
                  ],
                ),
              ),
              if (expandedSections.contains(sectionName)) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: students.isEmpty
                      ? Text(
                    'No students assigned',
                    style: TextStyle(color: Colors.grey),
                  )
                      : Column(
                    children: students.map((student) {
                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text(
                            '${student['first_name']} ${student['last_name']}'),
                        subtitle: Text('Username: ${student['username']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _removeStudentFromSection(student['student_id']),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              Divider(),
            ],
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
