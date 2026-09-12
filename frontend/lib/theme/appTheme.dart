// Dokumentasi:
// Konfigurasi tema visual aplikasi.
import 'package:flutter/material.dart';
import 'textTheme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    textTheme: AppTextTheme.textTheme,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,

      brightness: Brightness.light,
    ),

    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    textTheme: AppTextTheme.textTheme,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,

      brightness: Brightness.dark,
    ),

    useMaterial3: true,
  );
}
