import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_rev/screens/image-rainbows.dart';
import 'package:tech_rev/screens/image_rainbows_create.dart';
import 'package:tech_rev/screens/login_page.dart';
import 'package:tech_rev/screens/profile_settings.dart';
import 'package:tech_rev/screens/quiz_tech_create.dart';
import 'package:tech_rev/screens/sections.dart';

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
        title: Text('TECH REV'),
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
        title: Text('TECH REV'),
        backgroundColor: Colors.white,
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
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: userData!['prof_pic'] != null
                    ? NetworkImage(userData!['prof_pic'])
                    : AssetImage('assets/profile.png') as ImageProvider,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Welcome, ${userData!['full_name']}!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Account Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Username: ${userData!['username']}',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Account Type: ${widget.account}',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyStudent() {
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
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: userData!['prof_pic'] != null
                    ? NetworkImage(userData!['prof_pic'])
                    : AssetImage('assets/profile.png') as ImageProvider,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Welcome, ${userData!['full_name']}!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Account Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Username: ${userData!['username']}',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Account Type: ${widget.account}',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                color: Colors.black54,
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
            title: Text('Image Rainbow'),
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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Profile Settings'),
            onTap: _navigateToProfileSettings,
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
