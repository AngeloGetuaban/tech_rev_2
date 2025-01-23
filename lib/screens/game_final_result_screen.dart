import 'package:flutter/material.dart';
import 'package:tech_rev/screens/game_welcome_screen.dart';

class FinalResultScreen extends StatelessWidget {
  final Map<String, dynamic> gameData;

  FinalResultScreen({required this.gameData});

  @override
  Widget build(BuildContext context) {
    int player1Lives = gameData['player1Lives'];
    int player2Lives = gameData['player2Lives'];
    String player1 = gameData['player1'];
    String player2 = gameData['player2'];
    int totalRounds = gameData['totalRounds'];

    String winner = '';
    if (player1Lives > player2Lives) {
      winner = '$player1 Wins!';
    } else if (player2Lives > player1Lives) {
      winner = '$player2 Wins!';
    } else {
      winner = 'It\'s a Tie!';
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Final Result:',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '$player1: $player1Lives',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '$player2: $player2Lives',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Total Rounds Played: $totalRounds',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.teal.shade700,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      winner,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black38,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      child: Text('Play Again', style: TextStyle(color: Colors.white),),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WelcomeScreen(),
                          ), (route) => false, // Clear the entire navigation stack
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}