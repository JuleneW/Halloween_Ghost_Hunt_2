import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
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
                'Username',
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
                    '10',
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
                    'Expert',
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
