import 'package:flutter/material.dart';
import 'package:ghost_hunt/screens/home_screen.dart';

void main() {
  runApp(const GhostHuntApp());
}

class GhostHuntApp extends StatelessWidget {
  const GhostHuntApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ghost Hunt',
      home: HomeScreen(),
    );
  }
}
