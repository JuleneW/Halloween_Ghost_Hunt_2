import 'package:flutter/material.dart';
import 'package:ghost_hunt/screens/login_screen.dart';
import 'package:ghost_hunt/widgets/fitted_background_image_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              'Ghost Hunt',
              style: TextStyle(color: Colors.white, fontFamily: 'Creepster'),
              textScaler: TextScaler.linear(1.5),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent, // Transparante achtergrond
        ),
        // Zorg dat de body achter de AppBar begint
        extendBodyBehindAppBar: true,
        body: Stack(
          fit: StackFit.expand, // Makes the image fill the screen
          children: [
            BackgroundImage(),
            // Button positioned near the bottom
            Positioned(
              bottom: 100, // distance from bottom of the screen
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('Start'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
