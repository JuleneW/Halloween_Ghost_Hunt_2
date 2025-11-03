// import 'package:flutter/material.dart';
// import 'package:ghost_hunt/screens/welcome_screen.dart';
// import 'package:ghost_hunt/widgets/fitted_background_image_widget.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   String? _error;

//   void _onLogin() {
//     final username = _usernameController.text.trim();
//     if (username.isEmpty) {
//       setState(() => _error = 'Please enter a username');
//       return;
//     }

//     // Go to WelcomeScreen and let THAT screen talk to the database
//     Navigator.of(context).push(
//       MaterialPageRoute(builder: (_) => WelcomeScreen(username: username)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login screen')),
//       body: Stack(
//         children: [
//           const BackgroundImage(),
//           Center(
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.black.withValues(alpha: 0.5),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               width: 300,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Enter a username',
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: _usernameController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       hintText: 'Ghost hunter name',
//                       hintStyle: const TextStyle(color: Colors.white54),
//                       filled: true,
//                       fillColor: Colors.white10,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       errorText: _error,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _onLogin,
//                     child: const Text('Continue'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghost_hunt/screens/welcome_screen.dart';
import 'package:ghost_hunt/widgets/fitted_background_image_widget.dart';
import 'package:ghost_hunt/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String? _error;

  Future<void> _getUserLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permission denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permission permanently denied.');
        return;
      }

      globals.globalPosition = await Geolocator.getCurrentPosition();
      debugPrint('Location stored: ${globals.globalPosition}');
    } catch (e) {
      debugPrint('Error getting user location: $e');
    }
  }

  Future<void> _onLogin() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      setState(() => _error = 'Please enter a username');
      return;
    }

    // store globally
    globals.globalUsername = username;

    await _getUserLocation();

    if (!mounted) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const WelcomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login screen')),
      body: Stack(
        children: [
          const BackgroundImage(),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter a username',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ghost hunter name',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: _error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onLogin,
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
