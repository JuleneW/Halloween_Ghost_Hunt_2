import 'package:flutter/material.dart';
import 'package:ghost_hunt/models/ghost_type.dart';
import 'package:ghost_hunt/widgets/ghost_card.dart';

class GhostListWidget extends StatelessWidget {
  final List<GhostType> ghosts;
  final Set<String> caughtGhostTypeIds;
  final VoidCallback? onGhostCaught;

  const GhostListWidget({
    super.key,
    required this.ghosts,
    required this.caughtGhostTypeIds,
    this.onGhostCaught,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ghosts.length,
      itemBuilder: (context, index) {
        final ghost = ghosts[index];
        final isCaught =
            ghost.id != null && caughtGhostTypeIds.contains(ghost.id!);

        return GhostCard(
          ghost: ghost,
          isCaught: isCaught,
          onGhostCaught: onGhostCaught,
        );
      },
    );
  }
}
