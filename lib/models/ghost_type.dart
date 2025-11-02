// Deel van je data-model (bijv. ghost_type.dart)

class GhostType {
  final String? id;
  final String? name;
  final String? description;
  final String? rarity;
  final String? imageUrl;
  List<SpawnLocation> spawnLocations;

  GhostType({
    required this.id,
    this.name,
    this.description,
    this.rarity,
    this.imageUrl,
    required this.spawnLocations,
  });

  factory GhostType.fromJson(Map<String, dynamic> json) {
    // ... (bestaande fromJson code)
    return GhostType(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      rarity: json['rarity'] ?? '',
      imageUrl: (json['imageUrl'] as String?) ?? '',
      spawnLocations: (json['spawnLocations'] as List? ?? [])
          .map((e) => SpawnLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // NIEUW: Converteer de klasse naar een Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'rarity': rarity,
      'imageUrl': imageUrl,
      // Converteer de lijst van SpawnLocations naar een lijst van Maps
      'spawnLocations': spawnLocations.map((loc) => loc.toJson()).toList(),
    };
  }
}

// ...

class SpawnLocation {
  final double latitude;
  final double longitude;
  final int radius;
  final String locationName;

  SpawnLocation({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.locationName,
  });

  factory SpawnLocation.fromJson(Map<String, dynamic> json) {
    // ... (bestaande fromJson code)
    return SpawnLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: (json['radius'] as num).toInt(),
      locationName: json['locationName'] ?? '',
    );
  }

  // NIEUW: Converteer de klasse naar een Map
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'locationName': locationName,
    };
  }
}
