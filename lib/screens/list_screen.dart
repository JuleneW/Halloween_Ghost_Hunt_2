import 'package:flutter/material.dart';
import 'package:ghost_hunt/apis/inventoryItem.api.dart';
import 'package:ghost_hunt/models/ghost_type.dart';
import 'package:ghost_hunt/models/inventory_item.dart';
import 'package:ghost_hunt/models/player.dart';
import 'package:ghost_hunt/widgets/colour_background_widget.dart';
import 'package:ghost_hunt/widgets/ghost_list_widget.dart';
import 'package:ghost_hunt/widgets/list_info_widget.dart';
import 'package:ghost_hunt/widgets/profile_widget.dart';
import 'package:ghost_hunt/apis/ghostType.api.dart';

class ListScreen extends StatefulWidget {
  final Player player;
  final List<InventoryItem> inventoryItems;

  const ListScreen({
    super.key,
    required this.player,
    required this.inventoryItems,
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<GhostType>> _futureGhosts;
  late final Set<String> _caughtGhostTypeIds;
  List<GhostType> _allGhostTypes = [];

  @override
  void initState() {
    super.initState();
    _futureGhosts = GhostTypeApi.fetchGhostTypes();

    // build a fast lookup for "caught"
    _caughtGhostTypeIds = widget.inventoryItems
        .map((item) => item.ghostTypeId)
        .toSet();
  }

  Future<void> _reloadInventory() async {
    // player.id might be nullable depending on your model, so guard it
    final playerId = widget.player.id;
    if (playerId == null) return;

    final items = await InventoryItemApi.fetchInventoryItems(
      playerId,
    ); // get latest
    setState(() {
      _caughtGhostTypeIds = items
          .map((item) => item.ghostTypeId)
          .toSet(); // rebuild the set
    });
  }

  int _calculateScore() {
    int total = 0;

    for (final ghost in _allGhostTypes) {
      // ghost.id must match what you store in _caughtGhostTypeIds
      if (_caughtGhostTypeIds.contains(ghost.id)) {
        switch (ghost.rarity?.toLowerCase()) {
          case 'legendary':
            total += 50;
            break;
          case 'epic':
            total += 30;
            break;
          case 'rare':
            total += 20;
            break;
          default: // common or missing
            total += 10;
        }
      }
    }

    return total;
  }

  String _calculateLevel(int score) {
    if (score < 41) return 'Novice';
    if (score < 81) return 'Amateur';
    if (score < 121) return 'Elite';
    if (score < 151) return 'Mythic';
    if (score < 171) return 'Master';
    return 'Expert';
  }

  @override
  Widget build(BuildContext context) {
    final score = _calculateScore();
    final level = _calculateLevel(score);
    return Stack(
      children: [
        ColourBackgroundWidget(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileWidget(player: widget.player, score: score, level: level),
            ListInfoWidget(),
            Expanded(
              flex: 2,
              child: FutureBuilder<List<GhostType>>(
                future: _futureGhosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading ghosts'));
                  }
                  final ghosts = snapshot.data ?? [];
                  _allGhostTypes = ghosts;
                  return GhostListWidget(
                    ghosts: ghosts,
                    caughtGhostTypeIds: _caughtGhostTypeIds,
                    onGhostCaught: _reloadInventory,
                  );
                },
              ),
              // ],
            ),
          ],
        ),
      ],
    );
  }
}
