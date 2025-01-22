import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageRainbowPage extends StatelessWidget {
  final String studentId; // Passed from the dashboard

  const ImageRainbowPage({super.key, required this.studentId});

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
              'Welcome to Image Rainbow',
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
                'Start Now',
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
          title: Text('Warning',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              )),
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageRainbowGamePage(studentId: studentId),
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

class ImageRainbowGamePage extends StatefulWidget {
  final String studentId;

  const ImageRainbowGamePage({super.key, required this.studentId});

  @override
  State<ImageRainbowGamePage> createState() => _ImageRainbowGamePageState();
}

class _ImageRainbowGamePageState extends State<ImageRainbowGamePage> {
  List<dynamic> imageRainbows = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGameData();
  }

  Future<void> _fetchGameData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Step 1: Fetch student and get their section_name
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

      // Step 2: Fetch section and get the teacher_id
      final sectionResponse = await Supabase.instance.client
          .from('sections')
          .select()
          .eq('section_name', sectionName)
          .maybeSingle();

      if (sectionResponse == null || sectionResponse['teacher_id'] == null) {
        throw Exception('Section or teacher not found.');
      }

      final teacherId = sectionResponse['teacher_id'];

      // Step 3: Fetch image rainbows with the same teacher_id
      final rainbowsResponse = await Supabase.instance.client
          .from('image_rainbows')
          .select()
          .eq('teacher_id', teacherId);

      setState(() {
        imageRainbows = rainbowsResponse ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching game data: $e')),
      );
    }
  }

  void _handleAnswer(String selectedAnswer) {
    final correctAnswer = imageRainbows[currentQuestionIndex]['rainbow_correct_answer'];

    if (selectedAnswer == correctAnswer) {
      score++;
    }

    setState(() {
      if (currentQuestionIndex < imageRainbows.length - 1) {
        currentQuestionIndex++;
      } else {
        _showFinalScore();
      }
    });
  }

  void _showFinalScore() async {
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

      // Extract the current scores
      final latestScore = studentResponse['image_rainbow_latest_score'];

      if (latestScore == null) {
        // If `image_rainbow_latest_score` is empty, insert the current score
        await Supabase.instance.client.from('students').update({
          'image_rainbow_latest_score': score,
        }).eq('student_id', widget.studentId);
      } else {
        // If `image_rainbow_latest_score` is not empty, update the scores
        await Supabase.instance.client.from('students').update({
          'image_rainbow_prev_score': latestScore, // Move latest score to previous score
          'image_rainbow_latest_score': score,    // Update latest score to the new score
        }).eq('student_id', widget.studentId);
      }

      // Show the final score dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Game Over'),
          content: Text('Your score is $score/${imageRainbows.length}!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating score: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blueGrey[800],
          ),
        ),
      );
    }

    if (imageRainbows.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'No image rainbow data available.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
        ),
      );
    }

    final currentImageRainbow = imageRainbows[currentQuestionIndex];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey[50]!, Colors.blueGrey[100]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                'Guess the Image',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                  fontSize: 32, // Increased font size
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2), // Add a subtle shadow
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Image display (larger image)
              Container(
                width: 350, // Increased width
                height: 350, // Increased height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    currentImageRainbow['rainbow_image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 100, color: Colors.blueGrey[800]);
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Choices
              Column(
                children: [
                  // First row with 2 choices
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _buildChoiceButton(currentImageRainbow['rainbow_choice_1']),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _buildChoiceButton(currentImageRainbow['rainbow_choice_2']),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Second row with 2 choices
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _buildChoiceButton(currentImageRainbow['rainbow_choice_3']),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _buildChoiceButton(currentImageRainbow['rainbow_choice_4']),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButton(String choice) {
    return ElevatedButton(
      onPressed: () => _handleAnswer(choice),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      child: Text(
        choice,
        style: TextStyle(
          fontSize: 18,
          color: Colors.blueGrey[800],
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

