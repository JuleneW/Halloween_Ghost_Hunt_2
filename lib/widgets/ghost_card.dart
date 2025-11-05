import 'package:flutter/material.dart';
import 'package:ghost_hunt/models/ghost_type.dart';
import 'package:ghost_hunt/screens/ghost_detail_screen.dart';
import 'package:ghost_hunt/screens/unity_screen.dart';

class GhostCard extends StatelessWidget {
  final GhostType ghost;
  final bool isCaught;
  final VoidCallback? onGhostCaught;

  const GhostCard({
    super.key,
    required this.ghost,
    this.isCaught = false,
    this.onGhostCaught,
  });

  Widget _buildGhostImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset('assets/images/spirit.png', fit: BoxFit.cover);
    }

    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // if CORS blocks it or the image is gone:
          return Image.asset('assets/images/spirit.png', fit: BoxFit.cover);
        },
      );
    }

    // local relative path from backend or from assets
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
                        // 👇 clickable name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        GhostDetailScreen(ghost: ghost),
                                  ),
                                );
                              },
                              child: Text(
                                ghost.name ?? 'Ghost name',
                                style: const TextStyle(
                                  color: Colors.white, // 👻 white text
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Colors.white, // 👻 white underline
                                  fontSize: 20,
                                ),
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
                            if (!isCaught)
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
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute<bool>(
                                      builder: (context) =>
                                          UnityScreen(ghostType: ghost),
                                    ),
                                  );
                                  if (!context.mounted) return;
                                  // UnityScreen should do: Navigator.pop(context, true); when catch saved
                                  if (result == true) {
                                    // tell the parent to refresh inventory
                                    if (onGhostCaught != null) {
                                      onGhostCaught!();
                                    }

                                    // optional: little feedback
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Ghost caught!'),
                                      ),
                                    );
                                  }
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
          if (isCaught)
            Positioned.fill(
              child: IgnorePointer(
                child: Transform.rotate(
                  angle: -0.2,
                  child: Center(
                    child: Container(
                      height: 22, // thin ribbon (height = thickness)
                      color: const Color(0xFF1B5E20).withValues(alpha: 0.85),
                      alignment: Alignment.center,
                      child: const Text(
                        'CAUGHT',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16, // smaller letters
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          decoration: TextDecoration.none, // no underline
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
