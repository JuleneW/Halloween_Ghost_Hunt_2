import 'package:flutter/material.dart';

class GhostHuntAppbar extends StatelessWidget {
  const GhostHuntAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Text(
          'Ghost Hunt',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Creepster',
          ),
          textScaler: TextScaler.linear(1.5),
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent, // Transparante achtergrond
    );
  }
}
