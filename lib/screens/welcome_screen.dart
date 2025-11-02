import 'package:flutter/material.dart';
import 'package:ghost_hunt/apis/inventoryItem.api.dart';
import 'package:ghost_hunt/apis/player.api.dart';
import 'package:ghost_hunt/models/inventory_item.dart';
import 'package:ghost_hunt/models/player.dart';
import 'package:ghost_hunt/screens/list_screen.dart';
import 'package:ghost_hunt/widgets/colour_background_widget.dart';

class WelcomeScreen extends StatefulWidget {
  final String username;
  const WelcomeScreen({super.key, required this.username});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _message = '';

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
        // create new player
        player = await PlayerApi.createPlayer(widget.username);
      }

      // keep the welcome screen visible just a bit (like before)
      await Future.delayed(const Duration(seconds: 3));

      // 2. if we somehow ended up with a player without a valid numeric id,
      // just continue with an empty inventory
      if (player == null || player.id == null) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ListScreen(
              player: player ?? Player(username: widget.username),
              inventoryItems: const [],
            ),
          ),
        );
        return;
      }

      // 3. fetch inventory for THIS player (now we know we have an int id)
      List<InventoryItem> inventoryItems = [];
      try {
        inventoryItems = await InventoryItemApi.fetchInventoryItems(player.id!);
      } catch (_) {
        // if inventory doesn't exist yet → it's a new player → just show empty list
        inventoryItems = [];
      }

      // 4. go to list screen
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ListScreen(
            player: player ?? Player(username: widget.username),
            // 👇 again: this is the name your ListScreen expects
            inventoryItems: inventoryItems,
          ),
        ),
      );
    } catch (_) {
      // final safety net: even if something weird happens, still go to list
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ListScreen(
            // we at least know the username
            player: Player(username: widget.username),
            inventoryItems: const [],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ColourBackgroundWidget(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _message,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
