import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizTechCreatePage extends StatefulWidget {
  final String teacherId;

  const QuizTechCreatePage({super.key, required this.teacherId});

  @override
  State<QuizTechCreatePage> createState() => _QuizTechCreatePageState();
}

class _QuizTechCreatePageState extends State<QuizTechCreatePage> {
  List<dynamic> quizzes = [];
  List<dynamic> quizItems = [];
  bool isLoading = true;
  String? selectedQuizId;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('quizes')
          .select()
          .eq('teacher_id', widget.teacherId);

      setState(() {
        quizzes = response ?? [];
        if (quizzes.isNotEmpty) {
          selectedQuizId = quizzes.first['quiz_id'];
          _fetchQuizItems(selectedQuizId!);
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching quizzes: $e')),
      );
    }
  }

  Future<void> _fetchQuizItems(String quizId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('quiz_items')
          .select()
          .eq('quiz_id', quizId);

      setState(() {
        quizItems = response ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching quiz items: $e')),
      );
    }
  }

  Future<void> _addQuizItem(Map<String, dynamic> newQuizItem) async {
    try {
      // Step 1: Insert a new quiz if no quiz_id is selected
      if (selectedQuizId == null) {
        final quizResponse = await Supabase.instance.client.from('quizes').insert({
          'teacher_id': widget.teacherId,
        }).select('quiz_id').single();

        if (quizResponse != null) {
          selectedQuizId = quizResponse['quiz_id'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('New quiz created successfully!')),
          );
        } else {
          throw Exception('Failed to create a new quiz.');
        }
      }
      // Step 2: Insert the quiz item with the retrieved or selected quiz_id
      final quizItemWithQuizId = {
        ...newQuizItem,
        'quiz_id': selectedQuizId, // Add the selected or newly created quiz_id
      };

      await Supabase.instance.client.from('quiz_items').insert(quizItemWithQuizId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz item added successfully!')),
      );

      // Refresh the quiz items list
      if (selectedQuizId != null) _fetchQuizItems(selectedQuizId!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding quiz item: $e')),
      );
    }
  }

  void _showAddQuizItemDialog() {
    final TextEditingController questionController = TextEditingController();
    final TextEditingController answer1Controller = TextEditingController();
    final TextEditingController answer2Controller = TextEditingController();
    final TextEditingController answer3Controller = TextEditingController();
    final TextEditingController answer4Controller = TextEditingController();
    final TextEditingController correctAnswerController = TextEditingController();

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Quiz Item',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: answer1Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 1',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: answer2Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 2',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: answer3Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 3',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: answer4Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 4',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: correctAnswerController,
                  decoration: InputDecoration(
                    labelText: 'Correct Answer',
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
                        if (questionController.text.trim().isNotEmpty &&
                            answer1Controller.text.trim().isNotEmpty &&
                            answer2Controller.text.trim().isNotEmpty &&
                            answer3Controller.text.trim().isNotEmpty &&
                            answer4Controller.text.trim().isNotEmpty &&
                            correctAnswerController.text.trim().isNotEmpty &&
                            selectedQuizId != null) {
                          final newQuizItem = {
                            'quiz_id': selectedQuizId,
                            'item_question': questionController.text.trim(),
                            'item_answer_1': answer1Controller.text.trim(),
                            'item_answer_2': answer2Controller.text.trim(),
                            'item_answer_3': answer3Controller.text.trim(),
                            'item_answer_4': answer4Controller.text.trim(),
                            'item_correct_answer': correctAnswerController.text.trim(),
                          };
                          _addQuizItem(newQuizItem);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill all fields.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3A86FF),
                      ),
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Tech'),
        backgroundColor: const Color(0xFF3A86FF),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : quizzes.isEmpty
          ? Center(
        child: Text(
          'No quiz created yet.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      )
          : ListView.builder(
        itemCount: quizItems.length,
        itemBuilder: (context, index) {
          final item = quizItems[index];
          return ListTile(
            title: Text(item['item_question']),
            subtitle: Text('Correct Answer: ${item['item_correct_answer']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddQuizItemDialog,
        backgroundColor: const Color(0xFF3A86FF),
        child: Icon(Icons.add),
      ),
    );
  }
}