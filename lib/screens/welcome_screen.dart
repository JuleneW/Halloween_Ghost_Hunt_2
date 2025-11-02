import 'package:flutter/material.dart';
import 'package:ghost_hunt/apis/inventoryItem.api.dart';
import 'package:ghost_hunt/apis/player.api.dart';
import 'package:ghost_hunt/models/inventory_item.dart';
import 'package:ghost_hunt/models/player.dart';
import 'package:ghost_hunt/screens/list_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final String username;
  const WelcomeScreen({super.key, required this.username});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _message = 'Loading...';
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      // 1. check if player exists
      Player? player = await PlayerApi.getPlayerByName(widget.username);

      if (player != null) {
        setState(() {
          _message =
              'Welcome back, ${widget.username}!\nFetching your inventory...';
        });
      } else {
        setState(() {
          _message =
              'Welcome, ${widget.username}!\nFetching list of ghosts to catch.';
        });
        player = await PlayerApi.createPlayer(widget.username);
      }

      // ✨ debug: keep welcome screen visible for 1 second
      await Future.delayed(const Duration(seconds: 3));

      // 2. fetch inventory for THIS player
      final List<InventoryItem> inventoryItems =
          await InventoryItemApi.fetchInventoryItems(player.id!);

      // 3. go to list screen with the player + his inventory
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              ListScreen(player: player!, inventoryItems: inventoryItems),
        ),
      );
    } catch (e) {
      // if something goes wrong, show message instead of spinning forever
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_message, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                ],
              )
            : _error != null
            ? Text('Error: $_error', style: const TextStyle(color: Colors.red))
            : Text(_message),
      ),
    );
  }
}
