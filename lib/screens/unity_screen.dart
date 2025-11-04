import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:ghost_hunt/apis/inventoryItem.api.dart';
import 'package:ghost_hunt/apis/player.api.dart';
import 'package:ghost_hunt/globals.dart';
import 'package:ghost_hunt/models/ghost_type.dart';
import 'package:permission_handler/permission_handler.dart';

class UnityScreen extends StatefulWidget {
  final GhostType ghostType;

  const UnityScreen({super.key, required this.ghostType});

  @override
  State<UnityScreen> createState() => _UnityScreenState();
}

class _UnityScreenState extends State<UnityScreen> {
  bool _isCameraPermissionGranted = false;
  String unityMessage = '';

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
        child: EmbedUnity(onMessageFromUnity: _onUnityMessage),
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

  // void _onUnityMessage(String message) {
  //   developer.log('RECEIVED MESSAGE FROM UNITY: $message');

  //   // Save latest message for display (optional)
  //   setState(() {
  //     unityMessage = message;
  //   });

  //   // Respond to specific Unity signals
  //   if (message == "scene_loaded") {
  //     _sendLocation();
  //     _sendUsername();
  //   }

  //   // Optional: visual debug message on phone
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Unity: $message'),
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // }

  void _onUnityMessage(String message) async {
    developer.log('RECEIVED MESSAGE FROM UNITY: $message');

    // keep showing the latest message if you want
    setState(() {
      unityMessage = message;
    });

    // 1) some messages are just plain strings
    if (message == "scene_loaded") {
      _sendLocation();
      _sendUsername();
      return;
    }

    // 2) try to parse JSON messages (like the ones you showed)
    Map<String, dynamic>? data;
    try {
      data = jsonDecode(message) as Map<String, dynamic>;
    } catch (_) {
      // not JSON → just show it
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unity: $message')));
      return;
    }

    final key = data['key'] as String?;
    if (key == null) return;

    // ---- handle the different Unity messages ----
    if (key == 'GhostCatched') {
      final success = data['success'] == true;
      final ghostTypeId = data['ghostTypeId']?.toString();
      final username = data['username']?.toString();

      if (success && ghostTypeId != null && username != null) {
        try {
          // 1. find player by username
          final player = await PlayerApi.getPlayerByName(username);

          if (player != null) {
            // 2. add inventory item for this player
            await InventoryItemApi.addInventoryItem(player.id!, ghostTypeId);

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ghost added to inventory ✅')),
            );

            // 3. go back and tell previous screen to refresh
            Navigator.pop(context, true);
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Player "$username" not found')),
            );
          }
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error saving ghost: $e')));
        }
      } else {
        // Unity said it failed
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message']?.toString() ?? 'Catch failed'),
          ),
        );
      }
    } else if (key == 'catch_abort') {
      // user walked away
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message']?.toString() ?? 'Catch aborted')),
      );
    } else if (key == 'GhostCatchedFailed') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message']?.toString() ?? 'Catch failed')),
      );
    }
  }
}
