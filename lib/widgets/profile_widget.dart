import 'package:flutter/material.dart';
import 'package:ghost_hunt/models/player.dart';

class ProfileWidget extends StatelessWidget {
  final Player player;
  final int score;
  final String level;

  const ProfileWidget({
    super.key,
    required this.player,
    required this.score,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                player.username,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 5),
                  decoration: TextDecoration.none,
                  fontSize: 40,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Score',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 5),
                      decoration: TextDecoration.none,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    score.toString(),
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 5),
                      decoration: TextDecoration.none,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Level',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 5),
                      decoration: TextDecoration.none,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    level,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 5),
                      decoration: TextDecoration.none,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
