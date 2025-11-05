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

  // auto-closing dialog that also pops back
  void _showCaughtDialogAndReturn(BuildContext ctx, NavigatorState navigator) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (dialogContext) {
        // capture dialog navigator here (before async gap)
        final dialogNavigator = Navigator.of(dialogContext);

        Future.delayed(const Duration(seconds: 1), () {
          // close dialog first
          if (dialogNavigator.canPop()) {
            dialogNavigator.pop();
          }

          // then go back to list screen and tell it to refresh
          if (navigator.mounted) {
            navigator.pop(true);
          }
        });

        return const AlertDialog(
          title: Text(
            'Good job!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: Text('You caught the ghost!', textAlign: TextAlign.center),
        );
      },
    );
  }

  // Check for camera permission
  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
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


  void _onUnityMessage(String message) {
    developer.log('RECEIVED MESSAGE FROM UNITY: $message');

    if (mounted) {
      setState(() {
        unityMessage = message;
      });
    }

    // 1) some messages are just plain strings
    if (message == "scene_loaded") {
      _sendLocation();
      _sendUsername();
      return;
    }

    // 2) try to parse JSON messages
    Map<String, dynamic>? data;
    try {
      data = jsonDecode(message) as Map<String, dynamic>;
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unity: $message')));
      return;
    }

    final key = data['key'] as String?;
    if (key == null) return;

    if (key == 'GhostCatched') {
      // pull out fields first
      final success = data['success'] == true;
      final ghostTypeId = data['ghostTypeId']?.toString();
      final username = data['username']?.toString();

      // if invalid → handle here (sync) so the async method stays clean
      if (!(success && ghostTypeId != null && username != null)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message']?.toString() ?? 'Catch failed'),
          ),
        );
        return;
      }

      // valid → hand off to async method
      _handleGhostCatched(ghostTypeId, username);
    } else if (key == 'catch_abort') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message']?.toString() ?? 'Catch aborted')),
      );
      // Pop Unity and Details to return to List
      Navigator.pop(context); // Unity screen
      Navigator.pop(context); // Details screen
    } else if (key == 'GhostCatchedFailed') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message']?.toString() ?? 'Catch failed')),
      );
    }
  }

  // async method gets only validated params
  Future<void> _handleGhostCatched(String ghostTypeId, String username) async {
    // ✅ capture context-related stuff BEFORE any await
    if (!mounted) return;
    final ctx = context;
    final messenger = ScaffoldMessenger.of(ctx);
    final navigator = Navigator.of(ctx);

    try {
      // 1. find player by username
      final player = await PlayerApi.getPlayerByName(username);

      if (player != null) {
        // 2. add inventory item for this player
        await InventoryItemApi.addInventoryItem(player.id!, ghostTypeId);

        // 3. show snackbar
        messenger.showSnackBar(
          const SnackBar(content: Text('Ghost added to inventory ✅')),
        );

        // 4. show auto-close dialog + go back
        _showCaughtDialogAndReturn(ctx, navigator);
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text('Player "$username" not found')),
        );
      }
    } catch (e) {
      // still safe: we use captured messenger
      messenger.showSnackBar(SnackBar(content: Text('Error saving ghost: $e')));
    }
  }
}
