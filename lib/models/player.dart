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
