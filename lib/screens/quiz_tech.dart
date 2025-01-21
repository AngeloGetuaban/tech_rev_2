import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizTechPage extends StatelessWidget {
  final String studentId;

  const QuizTechPage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF6FE), Color(0xFFC8E4FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Quiz Tech',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _showWarningOverlay(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Color(0xFF3A86FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWarningOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Warning',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          content: Text(
            'If you proceed, you must not click the back arrow or go back. Your score will be forfeited and will automatically record as 0.',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the warning overlay
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the warning
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizTechGamePage(studentId: studentId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3A86FF),
              ),
              child: Text(
                'Proceed',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class QuizTechGamePage extends StatefulWidget {
  final String studentId;

  const QuizTechGamePage({super.key, required this.studentId});

  @override
  State<QuizTechGamePage> createState() => _QuizTechGamePageState();
}

class _QuizTechGamePageState extends State<QuizTechGamePage> {
  List<dynamic> quizItems = [];
  Map<int, String> selectedAnswers = {}; // Stores selected answers
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

  Future<void> _fetchQuizData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch quiz items based on the student ID, section, and teacher ID
      final studentResponse = await Supabase.instance.client
          .from('students')
          .select()
          .eq('student_id', widget.studentId)
          .maybeSingle();

      if (studentResponse == null || studentResponse['section_name'] == null) {
        // If section_name is null, navigate back and show a SnackBar
        Navigator.pop(context); // Go back to the previous page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add a section first to continue')),
        );
        return; // Stop further execution
      }

      final sectionName = studentResponse['section_name'];

      final sectionResponse = await Supabase.instance.client
          .from('sections')
          .select()
          .eq('section_name', sectionName)
          .maybeSingle();

      if (sectionResponse == null || sectionResponse['teacher_id'] == null) {
        throw Exception('Section or teacher not found.');
      }

      final teacherId = sectionResponse['teacher_id'];

      final quizItemsResponse = await Supabase.instance.client
          .from('quiz_items')
          .select()
          .eq('teacher_id', teacherId);

      setState(() {
        quizItems = quizItemsResponse ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching quiz data: $e')),
      );
    }
  }

  void _handleSubmit() async {
    int score = 0;

    // Calculate the score
    for (var i = 0; i < quizItems.length; i++) {
      if (selectedAnswers[i] == quizItems[i]['item_correct_answer']) {
        score++;
      }
    }

    try {
      // Fetch the student's current score details
      final studentResponse = await Supabase.instance.client
          .from('students')
          .select()
          .eq('student_id', widget.studentId)
          .maybeSingle();

      if (studentResponse == null) {
        throw Exception('Student not found.');
      }

      final latestScore = studentResponse['quiz_latest_score'];

      if (latestScore == null) {
        // If `quiz_latest_score` is empty, insert the new score
        await Supabase.instance.client.from('students').update({
          'quiz_latest_score': score,
        }).eq('student_id', widget.studentId);
      } else {
        // If `quiz_latest_score` is not empty, update both scores
        await Supabase.instance.client.from('students').update({
          'quiz_previous_score': latestScore, // Move latest score to previous score
          'quiz_latest_score': score,        // Update latest score to the new score
        }).eq('student_id', widget.studentId);
      }

      // Show the final score
      _showFinalScore(score);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating score: $e')),
      );
    }
  }

  void _showFinalScore(int score) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Completed'),
        content: Text('Your score is $score/${quizItems.length}!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to the previous page
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (quizItems.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'No quiz items available.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ...List.generate(quizItems.length, (index) {
              final quizItem = quizItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${index + 1}: ${quizItem['item_question']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        _buildRadioButton(
                          index,
                          quizItem['item_answer_1'],
                        ),
                        _buildRadioButton(
                          index,
                          quizItem['item_answer_2'],
                        ),
                        _buildRadioButton(
                          index,
                          quizItem['item_answer_3'],
                        ),
                        _buildRadioButton(
                          index,
                          quizItem['item_answer_4'],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Color(0xFF3A86FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(int questionIndex, String answer) {
    return ListTile(
      title: Text(answer),
      leading: Radio<String>(
        value: answer,
        groupValue: selectedAnswers[questionIndex],
        onChanged: (value) {
          setState(() {
            selectedAnswers[questionIndex] = value!;
          });
        },
      ),
    );
  }
}

