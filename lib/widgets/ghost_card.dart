import 'package:flutter/material.dart';
import 'package:ghost_hunt/models/ghost_type.dart';
import 'package:ghost_hunt/screens/unity_screen.dart';

class GhostCard extends StatelessWidget {
  final GhostType ghost;
  final bool isCatched;

  const GhostCard({super.key, required this.ghost, this.isCatched = false});

  Widget _buildGhostImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset('assets/images/spirit.png', fit: BoxFit.cover);
    }

    if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl, fit: BoxFit.cover);
    }

    return Image.asset(imageUrl, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // IMAGE
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: _buildGhostImage(ghost.imageUrl),
                    ),
                  ),
                  SizedBox(width: 10),
                  // TEXT + BUTTON
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ghost.name ?? 'Ghost name',
                              style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        // RARITY
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ghost.rarity ?? 'Rarity',
                              style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: 15,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                minimumSize: const Size(30, 30),
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) =>
                                        UnityScreen(ghostType: ghost),
                                  ),
                                );
                              },
                              child: const Text('GO!'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCatched)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Catched',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
