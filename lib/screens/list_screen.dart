import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _futureGhosts = GhostTypeApi.fetchGhostTypes();

    // build a fast lookup for "caught"
    _caughtGhostTypeIds = widget.inventoryItems
        .map((item) => item.ghostTypeId)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColourBackgroundWidget(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileWidget(player: widget.player),
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
                  return GhostListWidget(
                    ghosts: ghosts,
                    caughtGhostTypeIds: _caughtGhostTypeIds,
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
