import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF3B82F6),
      primary: const Color(0xFF3B82F6),
      secondary: const Color(0xFF9333EA),
    ),
    textTheme: GoogleFonts.interTextTheme(),
  );
}