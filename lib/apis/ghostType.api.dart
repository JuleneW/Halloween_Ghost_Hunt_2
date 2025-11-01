import 'dart:convert';
import 'package:ghost_hunt/models/ghost_type.dart';
import 'package:http/http.dart' as http;
import '../globals.dart';

class GhostTypeApi {
  static Future<List<GhostType>> fetchGhostTypes() async {
    var uri = Uri.parse("$server/ghost-types");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonobjects = json.decode(response.body);

      return jsonobjects
          .map((ghosttypemap) => GhostType.fromJson(ghosttypemap))
          .toList();
    } else {
      throw Exception('Failed to load ghost types');
    }
  }
}
