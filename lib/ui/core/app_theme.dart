import 'package:flutter/material.dart';

class AppTheme {
  static const seed = Color(0xFF1B4D3E);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seed),
      visualDensity: VisualDensity.standard,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
      visualDensity: VisualDensity.standard,
    );
  }
}
