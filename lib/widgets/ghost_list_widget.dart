import 'package:flutter/material.dart';
import 'package:ghost_hunt/models/ghost_type.dart';
import 'package:ghost_hunt/widgets/ghost_card.dart';

class GhostListWidget extends StatelessWidget {
  final List<GhostType> ghosts;
  final Set<int> caughtGhostTypeIds;

  const GhostListWidget({
    super.key,
    required this.ghosts,
    required this.caughtGhostTypeIds,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ghosts.length,
      itemBuilder: (context, index) {
        final ghost = ghosts[index];
        final isCatched = caughtGhostTypeIds.contains(ghost.id);
        return GhostCard(ghost: ghost, isCatched: isCatched);
      },
    );
  }
}
