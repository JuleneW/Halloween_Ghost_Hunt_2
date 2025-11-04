import 'dart:convert';
import 'dart:developer';
import 'package:ghost_hunt/globals.dart';
import 'package:ghost_hunt/models/inventory_item.dart';
import 'package:http/http.dart' as http;

class InventoryItemApi {
  /// Get all inventory items for ONE player
  static Future<List<InventoryItem>> fetchInventoryItems(int playerId) async {
    // for local json server
    // final uri = Uri.parse("$server/inventory?playerId=$playerId");
    // for spring backend
    final uri = Uri.parse("$server/inventory/player/$playerId");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((m) => InventoryItem.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load inventory for player $playerId');
    }
  }

  static Future<bool> addInventoryItem(int playerId, String ghostTypeId) async {
    final uri = Uri.parse("$server/inventory");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'playerId': playerId, 'ghostTypeId': ghostTypeId}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true; // success
    } else {
      log('Failed to add inventory item: ${response.statusCode}');
      return false;
    }
  }

  /// optional: catch a ghost for this player
  static Future<InventoryItem> catchGhost({
    required int playerId,
    required String ghostTypeId,
  }) async {
    final uri = Uri.parse("$server/inventory");
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"playerId": playerId, "ghostTypeId": ghostTypeId}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      return InventoryItem.fromJson(data);
    } else {
      throw Exception('Failed to catch ghost');
    }
  }
}
