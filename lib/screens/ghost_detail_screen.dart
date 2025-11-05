import 'package:flutter/material.dart';
import 'package:ghost_hunt/screens/unity_screen.dart';
import '../models/ghost_type.dart';
import '../widgets/colour_background_widget.dart'; // your existing one

class GhostDetailScreen extends StatelessWidget {
  final GhostType ghost;

  const GhostDetailScreen({super.key, required this.ghost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // so we see the gradient
      appBar: AppBar(
        title: Text(ghost.name ?? ''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1) your existing background widget (no changes to it)
          const ColourBackgroundWidget(),

          // 2) the actual content on top
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((ghost.imageUrl ?? '').isNotEmpty)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        ghost.imageUrl ?? '',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ghost.name ?? '',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ),
                    _RarityBadge(rarity: ghost.rarity),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  ghost.description ?? 'No description available.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 24),

                Text(
                  'Spawn locations',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                if (ghost.spawnLocations.isNotEmpty)
                  Column(
                    children: ghost.spawnLocations
                        .map(
                          (loc) => Card(
                            color: Colors.black45,
                            child: ListTile(
                              leading: const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                              ),
                              title: Text(
                                loc.locationName,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Lat: ${loc.latitude}, Lng: ${loc.longitude} • radius: ${loc.radius} m',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                else
                  const Text(
                    'No locations found.',
                    style: TextStyle(color: Colors.white70),
                  ),

                const SizedBox(height: 24),

                // Text(
                //   'ID: ${ghost.id}',
                //   style: const TextStyle(color: Colors.white38, fontSize: 12),
                // ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UnityScreen(ghostType: ghost),
                      ),
                    );
                  },
                  child: const Text('Start game'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RarityBadge extends StatelessWidget {
  final String? rarity;
  const _RarityBadge({this.rarity});

  Color _colorForRarity(String r) {
    switch (r.toUpperCase()) {
      case 'COMMON':
        return Colors.green;
      case 'RARE':
        return Colors.blue;
      case 'EPIC':
        return Colors.purple;
      case 'LEGENDARY':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (rarity == null || rarity!.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _colorForRarity(rarity!).withValues(alpha: .15),
        border: Border.all(color: _colorForRarity(rarity!)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        rarity!,
        style: TextStyle(
          color: _colorForRarity(rarity!),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
