import 'dart:convert';
import 'package:ghost_hunt/models/player.dart';
import 'package:http/http.dart' as http;
import 'package:ghost_hunt/globals.dart';

class PlayerApi {
  static Future<List<Player>> fetchPlayers() async {
    final uri = Uri.parse("$server/players");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data
          .map((m) => Player.fromJson(m as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load players (status ${response.statusCode})');
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
      throw Exception('Failed to save player (status ${response.statusCode})');
    }
  }

  // 1. check if player exists
  static Future<Player?> getPlayerByName(String username) async {
    // build URL safely
    final uri = Uri.parse(
      '$server/players',
    ).replace(queryParameters: {'username': username});

    final resp = await http.get(uri);

    // DEBUG
    // ignore: avoid_print
    print('GET $uri → ${resp.statusCode}');
    // ignore: avoid_print
    print('BODY: ${resp.body}');

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      if (data is List && data.isNotEmpty) {
        return Player.fromJson(data.first);
      }
      return null; // not found
    } else {
      throw Exception('Failed to load player (status ${resp.statusCode})');
    }
  }

  // 2. create player
  static Future<Player> createPlayer(String username) async {
    final uri = Uri.parse('$server/players');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );

    // DEBUG
    // ignore: avoid_print
    print('POST $uri → ${resp.statusCode}');
    // ignore: avoid_print
    print('BODY: ${resp.body}');

    if (resp.statusCode == 201 || resp.statusCode == 200) {
      return Player.fromJson(json.decode(resp.body));
    } else {
      throw Exception('Failed to create player (status ${resp.statusCode})');
    }
  }
}
