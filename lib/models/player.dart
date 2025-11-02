// // import 'package:ghost_hunt/utils/json_helpers.dart';

// class Player {
//   final int? id;
//   final String username;

//   Player({this.id, required this.username});

//   factory Player.fromJson(Map<String, dynamic> json) {
//     final dynamic rawId = json['id'];

//     int? parsedId;
//     if (rawId is int) {
//       parsedId = rawId;
//     } else if (rawId is String) {
//       parsedId = int.tryParse(rawId);
//     }

//     return Player(
//       id: parsedId, // can be null if parse failed
//       username: json['username'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       if (id != null) 'id': id, // json-server will add it if missing
//       'username': username,
//     };
//   }
// }

// lib/models/player.dart

class Player {
  final int? id;
  final String username;

  Player({this.id, required this.username});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: _toIntOrNull(json['id']),
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'username': username};
  }
}

// local helpers

int? _toIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
