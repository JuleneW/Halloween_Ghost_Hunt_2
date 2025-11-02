//
// lib/models/inventory_item.dart

class InventoryItem {
  final int id;
  final int playerId;
  final String ghostTypeId;

  InventoryItem({
    required this.id,
    required this.playerId,
    required this.ghostTypeId,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: _toInt(json['id']),
      playerId: _toInt(json['playerId']),
      // db.json sometimes gives "1", sometimes 1 -> always turn into String
      ghostTypeId: json['ghostTypeId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'playerId': playerId, 'ghostTypeId': ghostTypeId};
  }
}

// ---------- helpers (file-local) ----------

int _toInt(dynamic value) {
  if (value == null) {
    throw const FormatException('Expected int but got null');
  }
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw FormatException('Could not convert "$value" to int');
}
