import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blue,

// Scaffold
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white, size: 35),
      ),
      // Text
      textTheme: TextTheme(
        titleLarge: GoogleFonts.montserratAlternates(color: Colors.white),
        titleMedium:
            GoogleFonts.montserratAlternates(fontSize: 18, color: Colors.white),
        bodyLarge: GoogleFonts.montserratAlternates(color: Colors.white),
        bodyMedium:
            GoogleFonts.montserratAlternates(fontSize: 18, color: Colors.white),
      ));
}
