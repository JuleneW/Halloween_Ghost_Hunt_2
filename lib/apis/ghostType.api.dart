import 'dart:convert';
import 'package:ghost_hunt/models/ghost_type.dart';
import 'package:http/http.dart' as http;
import 'package:ghost_hunt/globals.dart';

// class GhostTypeApi {
//   static Future<List<GhostType>> fetchGhostTypes() async {
//     var uri = Uri.parse("$server/ghost-types");
//     final response = await http.get(uri);

//     if (response.statusCode == 200) {
//       List jsonobjects = json.decode(response.body);

//       return jsonobjects
//           .map((ghosttypemap) => GhostType.fromJson(ghosttypemap))
//           .toList();
//     } else {
//       throw Exception('Failed to load ghost types');
//     }
//   }
// }

class GhostTypeApi {
  static Future<List<GhostType>> fetchGhostTypes() async {
    final uri = Uri.parse('$server/ghost-types');
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => GhostType.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load ghost types');
    }
  }
}
