int? _toIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

int _toInt(dynamic value) {
  final result = _toIntOrNull(value);
  if (result == null) {
    throw FormatException('Could not convert "$value" to int');
  }
  return result;
}
