// Dokumentasi:
// Konfigurasi style teks aplikasi.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold),

    headlineMedium: GoogleFonts.outfit(
      fontSize: 24,

      fontWeight: FontWeight.bold,
    ),

    titleLarge: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),

    bodyLarge: GoogleFonts.outfit(fontSize: 16),

    bodyMedium: GoogleFonts.outfit(fontSize: 14),
  );
}
