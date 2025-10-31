import 'package:flutter/material.dart';
import 'package:ghost_hunt/widgets/ghost_card.dart';

class GhostListWidget extends StatefulWidget {
  // final List<String> items;
  const GhostListWidget({super.key});

  @override
  State<GhostListWidget> createState() => _GhostListWidgetState();
}

class _GhostListWidgetState extends State<GhostListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [GhostCard(), GhostCard(), GhostCard(), GhostCard()],
    );
  }
}
