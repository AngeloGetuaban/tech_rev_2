import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tech_rev/screens/image-rainbows.dart';
import 'package:tech_rev/screens/quiz_tech.dart';

class TriviaPage extends StatefulWidget {
  final String studentId;

  const TriviaPage({super.key, required this.studentId});

  @override
  State<TriviaPage> createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  Map<String, dynamic>? studentData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('students')
          .select()
          .eq('student_id', widget.studentId)
          .maybeSingle();

      setState(() {
        // Handle null values by assigning them explicitly
        studentData = {
          'image_rainbow_latest_score': response?['image_rainbow_latest_score'] ?? null,
          'image_rainbow_prev_score': response?['image_rainbow_prev_score'] ?? null,
          'quiz_latest_score': response?['quiz_latest_score'] ?? null,
          'quiz_previous_score': response?['quiz_previous_score'] ?? null,
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching student data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Trivia Time',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // Top Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey.shade100,
              ),
              child: Icon(
                Icons.lightbulb_outline, // A light bulb icon for trivia
                size: 50,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 40),

            // Button for Image Rainbow
            buildTriviaButton(
              context,
              icon: Icons.image,
              label: "Image Rainbow",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageRainbowPage(
                        studentId: widget.studentId),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Button for Quiz Tech
            buildTriviaButton(
              context,
              icon: Icons.quiz,
              label: "Quiz Tech",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuizTechPage(studentId: widget.studentId),
                  ),
                );
              },
            ),
            SizedBox(height: 40),

            // Display Scores
            if (studentData != null) ...[
              Divider(),
              Text(
                'Your Scores',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 10),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: [
                  _buildScoreRow(
                    'Latest Image Rainbow:',
                    studentData!['image_rainbow_latest_score']?.toString() ??
                        'N/A',
                  ),
                  _buildScoreRow(
                    'Previous Image Rainbow:',
                    studentData!['image_rainbow_prev_score']?.toString() ??
                        'N/A',
                  ),
                  _buildScoreRow(
                    'Latest Quiz:',
                    studentData!['quiz_latest_score']?.toString() ?? 'N/A',
                  ),
                  _buildScoreRow(
                    'Previous Quiz:',
                    studentData!['quiz_previous_score']?.toString() ??
                        'N/A',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Reusable button builder
  Widget buildTriviaButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade50,
        minimumSize: Size(double.infinity, 60), // Full width button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 20), // Left padding
          Icon(icon, color: Colors.blueGrey),
          SizedBox(width: 20), // Spacing between icon and text
          Text(
            label,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildScoreRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }
}
