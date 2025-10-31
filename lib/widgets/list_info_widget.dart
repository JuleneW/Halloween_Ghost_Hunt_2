import 'package:flutter/material.dart';

class ListInfoWidget extends StatelessWidget {
  const ListInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black38),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Which ghost do you want to slay today?',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tap the name to see details',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
