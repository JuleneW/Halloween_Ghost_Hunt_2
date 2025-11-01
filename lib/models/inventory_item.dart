class InventoryItem {
  final int id;
  final int playerId;
  final int ghostTypeId;

  InventoryItem({
    required this.id,
    required this.playerId,
    required this.ghostTypeId,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as int,
      playerId: json['playerId'] as int,
      ghostTypeId: json['ghostTypeId'] as int,
    );
  }
}
