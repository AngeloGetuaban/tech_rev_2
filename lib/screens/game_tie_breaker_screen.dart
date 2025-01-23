// game_tie_breaker_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TieBreakerScreen extends StatefulWidget {
  final String player1;
  final String player2;

  TieBreakerScreen({
    required this.player1,
    required this.player2,
  });

  @override
  _TieBreakerScreenState createState() => _TieBreakerScreenState();
}

class _TieBreakerScreenState extends State<TieBreakerScreen>
    with SingleTickerProviderStateMixin {
  String pointedPlayer = '';
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<Alignment> _animation;
  bool isArrowStopped = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _startPointing();
  }

  // Initializes the animation controller and animation
  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000), // Duration for one full cycle
      vsync: this,
    );

    // Defines the alignment animation from left to right
    _animation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Repeats the animation back and forth indefinitely
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    _animationController.forward();
    print('TieBreakerScreen Animation started.');
  }

  // Starts the pointing process with a random duration
  void _startPointing() {
    List<int> durationOptions = [5, 8, 10];
    int duration = durationOptions[Random().nextInt(durationOptions.length)];
    print('TieBreakerScreen will stop pointing after $duration seconds.');
    _timer = Timer(Duration(seconds: duration), _stopPointing);
  }

  // Stops the animation and determines which player the arrow is pointing to
  void _stopPointing() {
    _animationController.stop();
    setState(() {
      // Determine the current alignment to decide the pointed player
      // If the animation is closer to left, point to player1; else, player2
      Alignment currentAlignment = _animation.value;
      double dx = currentAlignment.x;
      if (dx < -0.2) {
        pointedPlayer = widget.player1;
      } else {
        pointedPlayer = widget.player2;
      }
      isArrowStopped = true;
      print('TieBreakerScreen selected: $pointedPlayer');
    });

    // Proceed to ask the selected player the question after a brief delay
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pop(context, pointedPlayer); // Return the selected player
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double arrowSize = 50.0; // Size of the arrow icon

    return Scaffold(
      appBar: AppBar(
        title: Text('Tie Breaker'),
        automaticallyImplyLeading: false, // Remove the back button
        backgroundColor: Colors.purple,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.purple.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: isArrowStopped
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$pointedPlayer will answer the question!',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Icon(
                Icons.arrow_forward,
                size: arrowSize,
                color: Colors.greenAccent,
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display Players
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPlayerInfo(widget.player1, Colors.redAccent),
                  _buildPlayerInfo(widget.player2, Colors.blueAccent),
                ],
              ),
              SizedBox(height: 50),
              // Animated Arrow
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Align(
                    alignment: _animation.value,
                    child: Icon(
                      Icons.arrow_upward,
                      size: arrowSize,
                      color: Colors.yellowAccent,
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'Pointing...',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds player info with avatar and name
  Widget _buildPlayerInfo(String player, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color,
          child: Text(
            player[0].toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          player,
          style: TextStyle(
            fontSize: 18,
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
      ],
    );
  }
}

