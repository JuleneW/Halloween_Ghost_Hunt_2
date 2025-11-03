import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:ghost_hunt/globals.dart';
import 'package:ghost_hunt/models/ghost_type.dart';
import 'package:permission_handler/permission_handler.dart';

class TestScreen extends StatefulWidget {
  final GhostType ghostType;
  const TestScreen({super.key, required this.ghostType});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool _isCameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  // Check for camera permission
  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.request(); // vragen van permissies
    setState(() {
      _isCameraPermissionGranted = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraPermissionGranted) {
      return const Center(
        child: Text('Camera permission is required to proceed.'),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Ghost Hunt")),
      body: Material(
        color: const Color.fromARGB(255, 76, 203, 203),
        child: EmbedUnity(
          onMessageFromUnity: (String message) {
            if (message == "scene_loaded") {
              _sendLocation();
              _sendUsername();
            }
          },
        ),
      ),
    );
  }

  // Send chosen location to Unity!
  void _sendLocation() {
    // moet de naam van het gameobject zijn, niet de naam van het script
    // de naam van de method
    // het object als string
    sendToUnity(
      "TargetLocation",
      "ReceiveTargetJson",
      jsonEncode(widget.ghostType.toJson()),
    );
  }

  // Send username to Unity!
  void _sendUsername() {
    sendToUnity("CurrentUser", "SetUsername", globalUsername);
  }

  void onUnityMessage(message) {
    developer.log('RECEIVED MESSAGE FROM UNITY: ${message.toString()}');
  }
}
