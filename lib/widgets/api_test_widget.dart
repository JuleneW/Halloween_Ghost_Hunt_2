import 'package:flutter/material.dart';
import 'package:ghost_hunt/apis/player.api.dart';
import 'package:ghost_hunt/models/player.dart';

class PlayerListPage extends StatefulWidget {
  const PlayerListPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State {
  List<Player> playerList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    _getPlayers();
  }

  void _getPlayers() {
    PlayerApi.fetchPlayers().then((result) {
      setState(() {
        playerList = result;
        count = result.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Players")),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: _playerListItems(),
      ),
    );
  }

  ListView _playerListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: Text(playerList[position].username),
        );
      },
    );
  }
}
