import 'package:flutter/material.dart';

/// Подбирает иконку по коду погоды WMO.
IconData iconForCode(int code) {
  if (code == 0) return Icons.wb_sunny;
  if (code == 1 || code == 2) return Icons.wb_cloudy;
  if (code == 3) return Icons.cloud;
  if (code == 45 || code == 48) return Icons.foggy;
  if (code >= 51 && code <= 57) return Icons.grain;
  if (code >= 61 && code <= 67) return Icons.water_drop;
  if (code >= 71 && code <= 77) return Icons.ac_unit;
  if (code >= 80 && code <= 82) return Icons.umbrella;
  if (code == 85 || code == 86) return Icons.snowing;
  if (code >= 95) return Icons.thunderstorm;
  return Icons.help_outline;
}

const List<String> weekdayNames = [
  'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс',
];
