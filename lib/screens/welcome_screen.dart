import 'package:flutter/material.dart';
import 'package:ghost_hunt/apis/inventoryItem.api.dart';
import 'package:ghost_hunt/apis/player.api.dart';
import 'package:ghost_hunt/models/player.dart';
// import 'package:ghost_hunt/models/inventory_item.dart';
import 'package:ghost_hunt/screens/list_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final String username;
  const WelcomeScreen({super.key, required this.username});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _message = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // 1. check if player exists
    Player? player = await PlayerApi.getPlayerByName(widget.username);

    if (player != null) {
      setState(() => _message = 'Welcome back, ${widget.username}!');
    } else {
      setState(() => _message = 'Welcome, ${widget.username}!');
      player = await PlayerApi.createPlayer(widget.username);
    }

    // 2. fetch inventory for THIS player
    final inventoryItems = await InventoryItemApi.fetchInventoryItems(
      player.id!,
    );

    // 3. go to list screen with the player + his inventory
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            ListScreen(player: player!, inventoryItems: inventoryItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_message, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
