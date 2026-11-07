/// Text helpers shared by the scenes (pt-BR).
library;

/// `240` -> `4 min`. Never shows less than 1 min.
String formatEta(int seconds) {
  final minutes = (seconds / 60).round();
  return '${minutes < 1 ? 1 : minutes} min';
}

/// `850` -> `850 g`, `2140` -> `2,1 kg`.
String formatCo2(int grams) {
  if (grams < 1000) return '$grams g';
  return '${_oneDecimal(grams / 1000)} kg';
}

/// `850` -> `850 m`, `14230` -> `14,2 km`.
String formatDistance(int meters) {
  if (meters < 1000) return '$meters m';
  return '${_oneDecimal(meters / 1000)} km';
}

String _oneDecimal(double value) =>
    value.toStringAsFixed(1).replaceAll('.', ',');
