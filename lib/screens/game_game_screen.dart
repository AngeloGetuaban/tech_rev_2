import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'game_final_result_screen.dart';
import 'game_tie_breaker_screen.dart';

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;

  GameScreen({required this.player1, required this.player2});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late String currentPlayer;
  List<String> board = List.filled(9, '');
  bool isPlayer1Turn = true;

  // Local variables for player names
  late String player1;
  late String player2;

  // Question Management
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the first step in installing an operating system (OS)?',
      'options': ['Boot from the installation media', 'Install the OS drivers', 'Partition the hard drive', 'Configure network settings'],
      'correctAnswer': 'Boot from the installation media',
    },
    {
      'question': 'Which of the following is a common method to configure a modem?',
      'options': ['Accessing the modem\'s web interface', 'Using a command line interface', 'Resetting the modem physically', 'Rebooting the modem'],
      'correctAnswer': 'Accessing the modem\'s web interface',
    },
    {
      'question': 'Which component is responsible for storing data permanently in a computer?',
      'options': ['RAM', 'Hard Drive', 'Motherboard', 'CPU'],
      'correctAnswer': 'Hard Drive',
    },
    {
      'question': 'Which tool is most commonly used to secure screws when assembling a computer?',
      'options': ['Wrench', 'Pliers', 'Hammer', 'Screwdriver'],
      'correctAnswer': 'Screwdriver',
    },
    {
      'question': 'What is the purpose of creating partitions during OS installation?',
      'options': ['To divide the storage into sections for easier management', 'To enhance the graphics', 'To improve the OS boot speed', 'To increase the RAM size'],
      'correctAnswer': 'To divide the storage into sections for easier management',
    },
    {
      'question': 'What is the primary function of a modem in a network?',
      'options': ['To convert digital signals to analog and vice versa', 'To manage IP addresses', 'To store data', 'To handle video calls'],
      'correctAnswer': 'To convert digital signals to analog and vice versa',
    },
    {
      'question': 'Which of the following is NOT a part of the system unit?',
      'options': ['Monitor', 'CPU', 'Motherboard', 'Hard Drive'],
      'correctAnswer': 'Monitor',
    },
    {
      'question': 'What should you do to prevent electrostatic discharge (ESD) when handling computer components?',
      'options': ['Ground yourself using an anti-static wrist strap', 'Touch the power supply before handling components', 'Work on a plastic surface', 'Use rubber gloves'],
      'correctAnswer': 'Ground yourself using an anti-static wrist strap',
    },
    {
      'question': 'Which of the following is required to activate most modern operating systems after installation?',
      'options': ['A product key', 'A fingerprint scanner', 'A network connection', 'A USB drive'],
      'correctAnswer': 'A product key',
    },
    {
      'question': 'Which component connects all the hardware components of a computer?',
      'options': ['Motherboard', 'Hard Drive', 'Power Supply', 'Graphics Card'],
      'correctAnswer': 'Motherboard',
    },

    // Add more questions as needed
  ];

  int currentQuestionIndex = 0;
  int player1Lives = 5;
  int player2Lives = 5;
  int currentRound = 1; // Tracks the current round

  // Animation Controller for Winning Animation
  late AnimationController _winAnimationController;
  late Animation<double> _winAnimation;

  @override
  void initState() {
    super.initState();
    currentPlayer = widget.player1;

    // Initialize local variables
    player1 = widget.player1;
    player2 = widget.player2;

    _winAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _winAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _winAnimationController, curve: Curves.easeInOut),
    );

    // Shuffle questions to ensure randomness
    questions.shuffle(Random());
    print('Questions shuffled. Total questions: ${questions.length}');
  }

  @override
  void dispose() {
    _winAnimationController.dispose();
    super.dispose();
  }

  // Handle tap on the game board
  Future<void> _handleTap(int index) async {
    if (board[index] == '') {
      // Debugging: Print current state
      print('--- Handle Tap ---');
      print('Round: $currentRound');
      print('Question Index: $currentQuestionIndex');
      print('Player1 Lives: $player1Lives');
      print('Player2 Lives: $player2Lives');

      // Step 1: Determine the current player's symbol
      String symbol = isPlayer1Turn ? 'X' : 'O';

      // Step 2: Update the board synchronously
      setState(() {
        board[index] = symbol;
      });

      // Step 3: Check for a winner using the current player's symbol
      if (_checkWinner(symbol)) {
        print('$currentPlayer wins Round $currentRound');
        // Current player wins the round
        await _showWinnerDialog(currentPlayer);
        return; // Exit the function after handling the win
      }

      // Step 4: Check for a tie
      if (!board.contains('')) {
        print('Round $currentRound ended in a tie.');
        // It's a tie, navigate to TieBreakerScreen
        String? selectedPlayer = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TieBreakerScreen(
              player1: widget.player1,
              player2: widget.player2,
            ),
          ),
        );

        // Step 5: Handle the result from TieBreakerScreen
        if (selectedPlayer != null) {
          print('TieBreaker selected player: $selectedPlayer');
          bool gameEnded = await _askQuestion(selectedPlayer);
          if (!gameEnded) {
            _startNextRound();
          }
        }
        return; // Exit after handling the tie
      }

      // Step 6: Switch turns only if there's no winner and no tie
      setState(() {
        isPlayer1Turn = !isPlayer1Turn;
        currentPlayer = isPlayer1Turn ? player1 : player2;
        print('Switched turn to $currentPlayer');
      });
    }
  }

  // Checks if the given symbol has a winning combination
  bool _checkWinner(String symbol) {
    List<List<int>> winningPositions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pos in winningPositions) {
      if (board[pos[0]] == symbol &&
          board[pos[1]] == symbol &&
          board[pos[2]] == symbol) {
        return true;
      }
    }
    return false;
  }

  // Displays a dialog when a player wins a round
  Future<void> _showWinnerDialog(String winner) async {
    // Start the animation
    _winAnimationController.forward();

    await showDialog(
      context: context,
      builder: (ctx) => ScaleTransition(
        scale: _winAnimation,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Round $currentRound Winner!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Text(
            '$winner wins Round $currentRound.',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                // Stop the animation after dialog is dismissed
                _winAnimationController.reset();
                await _handleGameResult(winner: winner, tied: false);
              },
              child: Text(
                'OK',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGameResult({required String winner, required bool tied}) async {
    print('Handling game result. Winner: $winner, Tied: $tied');
    print('Current Question Index: $currentQuestionIndex, Total Questions: ${questions.length}');
    print('Player1 Lives: $player1Lives, Player2 Lives: $player2Lives');

    // End the game immediately if a player loses all lives
    if (player1Lives <= 0 || player2Lives <= 0) {
      _endGame();
      return;
    }

    // End the game when all questions are answered
    if (currentQuestionIndex >= questions.length) {
      print('All questions answered. Ending game.');
      _endGame();
      return;
    }

    // Continue with the next round if neither condition is met
    if (!tied) {
      // Determine the loser to ask the question
      String loserPlayer = (winner == player1) ? player2 : player1;
      print('Asking question to loser: $loserPlayer');
      bool gameEnded = await _askQuestion(loserPlayer);

      // If the game ended, no need to continue
      if (gameEnded) {
        return;
      } else {
        // If the game didn't end, start the next round
        _startNextRound();
      }
    } else {
      // Tie was already handled by TieBreakerScreen and question was asked
      // Start the next round
      _startNextRound();
    }
  }


  Future<bool> _askQuestion(String player) async {
    if (currentQuestionIndex >= questions.length) {
      print('No more questions available.');
      // No more questions, navigate to final result
      _endGame();
      return true; // Game ended
    }

    var questionData = questions[currentQuestionIndex];
    var question = questionData['question'];
    var options = questionData['options'] as List<String>;
    var correctAnswer = questionData['correctAnswer'];

    String? selectedOption;

    print('Asking Question ${currentQuestionIndex + 1}: $question');

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                '$player\'s Turn',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      question,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ...List<Widget>.generate(options.length, (index) {
                      return RadioListTile<String>(
                        title: Text(
                          options[index],
                          style: TextStyle(fontSize: 16),
                        ),
                        value: options[index],
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: selectedOption == null
                      ? null
                      : () async {
                    String userAnswer = selectedOption!.trim();

                    print('$player selected: $userAnswer');

                    if (userAnswer.toLowerCase() == correctAnswer.toString().toLowerCase()) {
                      // Correct answer
                      print('Correct Answer!');
                      Navigator.of(ctx).pop();
                      setState(() {
                        currentQuestionIndex++;
                        print('Incremented currentQuestionIndex to $currentQuestionIndex');
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Correct Answer!'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      // Wrong answer, decrease lives
                      print('Wrong Answer!');
                      setState(() {
                        if (player == player1) {
                          player1Lives--;
                          print('$player1Lives lives remaining for $player1');
                          if (player1Lives <= 0) {
                            player1Lives = 0;
                            print('$player1 has lost all lives.');
                            Navigator.of(ctx).pop();
                            _endGame(); // End the game immediately
                            return;
                          }
                        } else {
                          player2Lives--;
                          print('$player2Lives lives remaining for $player2');
                          if (player2Lives <= 0) {
                            player2Lives = 0;
                            print('$player2 has lost all lives.');
                            Navigator.of(ctx).pop();
                            _endGame(); // End the game immediately
                            return;
                          }
                        }
                        currentQuestionIndex++;
                        print('Incremented currentQuestionIndex to $currentQuestionIndex');
                      });
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Wrong Answer!'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }

                    // Check if all questions have been answered
                    if (currentQuestionIndex >= questions.length) {
                      _endGame(); // End the game immediately
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    // Return true if the game ended (lives exhausted or no questions left)
    if (player1Lives <= 0 || player2Lives <= 0 || currentQuestionIndex >= questions.length) {
      return true;
    } else {
      return false;
    }
  }


// Displays a game over dialog when a player loses all lives
  Future<void> _showGameOver(String winner) async {
    // Start the animation
    _winAnimationController.forward();

    await showDialog(
      context: context,
      builder: (ctx) => ScaleTransition(
        scale: _winAnimation,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Game Over',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Text(
            '$winner wins the game!',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                // Stop the animation after dialog is dismissed
                _winAnimationController.reset();
                _endGame();
              },
              child: Text(
                'OK',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Initiates the next round by resetting the board and updating the round counter
  void _startNextRound() {
    setState(() {
      board = List.filled(9, '');
      isPlayer1Turn = Random().nextBool(); // Randomize who starts
      currentPlayer = isPlayer1Turn ? player1 : player2;
      currentRound++;
      print('--- Starting Round $currentRound ---');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting Round $currentRound'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _endGame() {
    print('Ending game.');

    // Prepare game data to pass to FinalResultScreen
    Map<String, dynamic> gameData = {
      'player1Lives': player1Lives,
      'player2Lives': player2Lives,
      'player1': player1,
      'player2': player2,
      'totalRounds': currentRound,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinalResultScreen(gameData: gameData), // Pass gameData directly
      ), // Clear the entire navigation stack
    );
  }


  @override
  Widget build(BuildContext context) {
    double boardSize = MediaQuery.of(context).size.width - 40;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display Round Number
              Text(
                'Round $currentRound',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Display Current Player
              Text(
                'Current Player: $currentPlayer',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black45,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Display Lives
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLifeIndicator(player1, player1Lives, Colors.redAccent),
                  SizedBox(width: 40),
                  _buildLifeIndicator(player2, player2Lives, Colors.blueAccent),
                ],
              ),
              SizedBox(height: 10),
              // Display Question Progress
              Text(
                'Question ${currentQuestionIndex + 1} of ${questions.length}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
              // Game Board
              Container(
                width: boardSize,
                height: boardSize,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: 9,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () => _handleTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal),
                          color: board[index] == ''
                              ? Colors.white
                              : (board[index] == 'X'
                              ? Colors.red.shade100
                              : Colors.blue.shade100),
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: Text(
                              board[index],
                              key: ValueKey<String>(board[index]),
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color:
                                board[index] == 'X' ? Colors.red : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
              // End Game Button
              ElevatedButton(
                onPressed: _endGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'End Game',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Optional: Add a "Help" or "Info" Button
              // You can add more interactive buttons or information here as needed
            ],
          ),
        ),
      ),
    );
  }

  // Builds a life indicator with heart icons
  Widget _buildLifeIndicator(String player, int lives, Color color) {
    return Column(
      children: [
        Text(
          '$player Lives:',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              Icons.favorite,
              color: index < lives ? color : Colors.white54,
              size: 24,
            );
          }),
        ),
      ],
    );
  }
}
