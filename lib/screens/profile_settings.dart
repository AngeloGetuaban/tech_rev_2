import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tech_rev/screens/edit_field_page.dart';
import 'package:tech_rev/screens/edit_password_page.dart';
import 'package:tech_rev/screens/edit_username_page.dart';

class ProfileSettingsPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfileSettingsPage({super.key, required this.userData});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    userData = _handleNullValues(widget.userData);
  }

  Map<String, dynamic> _handleNullValues(Map<String, dynamic> data) {
    // Replace null values with fallback values
    return {
      'student_id': data['student_id'] ?? '',
      'teacher_id': data['teacher_id'] ?? '',
      'full_name': data['full_name'] ?? 'Unknown',
      'username': data['username'] ?? 'Unknown',
      'prof_pic': data['prof_pic'], // Can remain null
      'account': data['account'] ?? 'Unknown',
    };
  }

  Future<void> _refreshUserData() async {
    try {
      // Determine the table and ID field
      final tableName =
      userData['account'].toLowerCase() == 'teacher' ? 'teachers' : 'students';
      final idField =
      userData['account'].toLowerCase() == 'teacher' ? 'teacher_id' : 'student_id';
      final idValue = userData[idField];

      // Fetch updated data from Supabase
      final response = await Supabase.instance.client
          .from(tableName)
          .select()
          .eq(idField, idValue)
          .single();

      if (response != null) {
        setState(() {
          // Preserve the 'account' value
          final preservedAccount = userData['account'];

          // Update userData while keeping 'account' unchanged
          userData = _handleNullValues(response);
          userData['account'] = preservedAccount; // Reassign preserved value
        });

        // Update SharedPreferences for the updated fields (excluding account)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', userData['username']);
        await prefs.setString('full_name', userData['full_name']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile refreshed successfully!')),
        );
      } else {
        throw Exception('Failed to refresh data.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error refreshing profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
        backgroundColor: const Color(0xFF3A86FF),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUserData,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEAF6FE), Color(0xFFC8E4FD)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              SizedBox(height: 30),
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: userData['prof_pic'] != null
                      ? NetworkImage(userData['prof_pic'])
                      : AssetImage('assets/profile.png') as ImageProvider,
                ),
              ),
              SizedBox(height: 30),
              Divider(),
              ListTile(
                title: Text('Full Name'),
                subtitle: Text(userData['full_name']),
                leading: Icon(Icons.edit),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditFieldPage(
                        title: 'Edit Full Name',
                        student_id: userData['student_id'],
                        teacher_id: userData['teacher_id'],
                        fieldName: 'full_name',
                        initialValue: userData['full_name'],
                        account: userData['account'],
                      ),
                    ),
                  ).then((updatedValue) {
                    if (updatedValue != null) {
                      setState(() {
                        userData['full_name'] = updatedValue;
                      });
                    }
                  });
                },
              ),
              Divider(),
              ListTile(
                title: Text('Account'),
                subtitle: Text(userData['account']),
                leading: Icon(Icons.account_circle),
              ),
              Divider(),
              ListTile(
                title: Text('Username'),
                subtitle: Text(userData['username']),
                leading: Icon(Icons.edit),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUsernamePage(
                        title: 'Edit Username',
                        student_id: userData['student_id'],
                        teacher_id: userData['teacher_id'],
                        fieldName: 'username',
                        initialValue: userData['username'],
                        account: userData['account'],
                      ),
                    ),
                  ).then((updatedValue) {
                    if (updatedValue != null) {
                      setState(() {
                        userData['username'] = updatedValue;
                      });
                    }
                  });
                },
              ),
              Divider(),
              ListTile(
                title: Text('Edit Password'),
                leading: Icon(Icons.lock),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPasswordPage(
                        student_id: userData['student_id'],
                        teacher_id: userData['teacher_id'],
                        account: userData['account'],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
