import 'dart:convert';
// import 'package:ghost_hunt/models/inventory_item.dart';
import 'package:ghost_hunt/models/player.dart';
import 'package:http/http.dart' as http;
import '../globals.dart';

class PlayerApi {
  static Future<List<Player>> fetchPlayers() async {
    final uri = Uri.parse("$server/players");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((m) => Player.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load players');
    }
  }

  static Future<void> savePlayer(Player player) async {
    final uri = Uri.parse("$server/players");
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(player.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      // Backend likely throws when username exists; bubble up for caller to decide.
      throw Exception('Failed to save player (status ${response.statusCode})');
    }
  }

  // 1. check if user exists
  static Future<Player?> getPlayerByName(String username) async {
    final uri = Uri.parse('$server/players?username=$username');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is List && data.isNotEmpty) {
        return Player.fromJson(data[0]);
      }
    }
    return null;
  }

  // 2. create user
  static Future<Player> createPlayer(String username) async {
    final uri = Uri.parse('$server/players');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );

    if (resp.statusCode == 201 || resp.statusCode == 200) {
      return Player.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Could not create user');
    }
  }
}
