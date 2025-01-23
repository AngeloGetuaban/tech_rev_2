import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_rev/screens/edit_section_page.dart';
import 'package:tech_rev/screens/image-rainbows.dart';
import 'package:tech_rev/screens/image_rainbows_create.dart';
import 'package:tech_rev/screens/login_page.dart';
import 'package:tech_rev/screens/module_screen.dart';
import 'package:tech_rev/screens/profile_settings.dart';
import 'package:tech_rev/screens/quiz_tech_create.dart';
import 'package:tech_rev/screens/sections.dart';
import 'package:tech_rev/screens/trivia_page.dart';

class DashboardPage extends StatefulWidget {
  final String username;
  final String account; // 'teacher' or 'student'

  const DashboardPage({super.key, required this.username, required this.account});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final tableName = widget.account.toLowerCase() == 'teacher' ? 'teachers' : 'students';

      final response = await Supabase.instance.client
          .from(tableName)
          .select()
          .eq('username', widget.username)
          .maybeSingle();

      if (response != null) {
        setState(() {
          userData = response;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found in $tableName!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
      print('$e');
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchStudentData() async {
    try {
      // Fetch sections with the same teacher_id
      final sectionsResponse = await Supabase.instance.client
          .from('sections')
          .select('section_name')
          .eq('teacher_id', userData!['teacher_id']);

      if (sectionsResponse == null || sectionsResponse.isEmpty) {
        return [];
      }

      // Extract section names
      final sectionNames = List<String>.from(
          sectionsResponse.map((section) => section['section_name']));

      // Construct `or` filter for Supabase query
      final orFilter = sectionNames
          .map((name) => 'section_name.eq.$name')
          .join(',');

      // Fetch students belonging to these sections
      final studentsResponse = await Supabase.instance.client
          .from('students')
          .select()
          .or(orFilter);

      return List<Map<String, dynamic>>.from(studentsResponse ?? []);
    } catch (e) {
      print('Error fetching student data: $e');
      throw Exception('Failed to fetch student data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.account.toLowerCase() == 'teacher') {
      return _buildTeacherScaffold();
    } else {
      return _buildStudentScaffold();
    }
  }

  Widget _buildTeacherScaffold() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: _buildTeacherDrawer(),
      body: _buildBodyTeacher(),
    );
  }

  Widget _buildStudentScaffold() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0,
      ),
      drawer: _buildStudentDrawer(),
      body: _buildBodyStudent(),
    );
  }

  Widget _buildBodyTeacher() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEAF6FE), Color(0xFFC8E4FD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: userData == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchStudentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No students found.'));
          }

          final students = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Text
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    'WELCOME TO TECHREV TEACHER DASHBOARD',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Students Overview Title
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    'Students Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // DataTable
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              'Student Names',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Image Rainbow',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Quiz Tech',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Section',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                        rows: students.map((student) {
                          return DataRow(cells: [
                            DataCell(
                              Text(
                                student['full_name'] ?? 'N/A',
                                overflow: TextOverflow.ellipsis, // Truncate long text
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${student['image_rainbow_latest_score'] ?? 'N/A'} (${student['image_rainbow_prev_score'] ?? 'N/A'})',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${student['quiz_latest_score'] ?? 'N/A'} (${student['quiz_previous_score'] ?? 'N/A'})',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${student['section_name'] ?? 'N/A'}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildBodyStudent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blueGrey[800]!, Colors.blueGrey[900]!],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome Text
            Text(
              'WELCOME TO TECHREV',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // Icon (Brain)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey.shade100.withOpacity(0.2),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.memory, // Brain-like icon
                size: 50,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),

            // MODULE Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [Colors.blueGrey[600]!, Colors.blueGrey[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModulesScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.book, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      'MODULE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // TRIVIA TIME Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [Colors.blueGrey[600]!, Colors.blueGrey[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TriviaPage(studentId: userData!['student_id']),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.lightbulb, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      'TRIVIA TIME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


Widget _buildTeacherDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Profile Settings'),
            onTap: _navigateToProfileSettings,
          ),
          ListTile(
            leading: Icon(Icons.add_business_rounded),
            title: Text('Student and Sections'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SectionsPage(teacherId: userData!['teacher_id'])),
              );
            }
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Guess the Picture'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageRainbowCreatePage(teacherId: userData!['teacher_id'])),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.quiz),
            title: Text('Quiz Tech'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizTechCreatePage(teacherId: userData!['teacher_id'])),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey[800]!, Colors.blueGrey[900]!],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text(
                'Profile Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: _navigateToProfileSettings,
            ),
            Divider(color: Colors.white.withOpacity(0.2)),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.white),
              title: Text(
                'Edit Section',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditSectionPage(student: userData!['student_id']),
                  ),
                );
              },
            ),
            Divider(color: Colors.white.withOpacity(0.2)),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red[400]),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.red[400]),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(
        userData?['full_name'] ?? 'Loading...',
        style: TextStyle(color: Colors.black),
      ),
      accountEmail: Text(
        widget.account,
        style: TextStyle(color: Colors.black),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: userData?['prof_pic'] != null
            ? NetworkImage(userData!['prof_pic'])
            : AssetImage('assets/profile.png') as ImageProvider,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEAF6FE), Color(0xFFC8E4FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  void _navigateToProfileSettings() {
    if (userData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSettingsPage(
            userData: {
              'teacher_id': userData!['teacher_id'] ?? '',
              'student_id': userData!['student_id'] ?? '',
              'full_name': userData!['full_name'] ?? 'N/A',
              'username': userData!['username'] ?? 'N/A',
              'account': widget.account,
              'prof_pic': userData!['prof_pic'],
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data is still loading. Please wait.')),
      );
    }
  }
}
