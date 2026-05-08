import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Color Tokens ────────────────────────────────────────────────────────────
  static const Color _lightPrimary = Color(0xFF1A5CFF);
  static const Color _lightSecondary = Color(0xFF26A69A);
  static const Color _lightBackground = Color(0xFFF5F7FA);
  static const Color _lightSurface = Colors.white;
  static const Color _lightOnPrimary = Colors.white;

  static const Color _darkPrimary = Color(0xFF4D8AFF);
  static const Color _darkSecondary = Color(0xFF26A69A);
  static const Color _darkBackground = Color(0xFF0F1117);
  static const Color _darkSurface = Color(0xFF1C1F2E);
  static const Color _darkOnPrimary = Colors.white;

  // ── Light Theme ─────────────────────────────────────────────────────────────
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _lightPrimary,
      brightness: Brightness.light,
      primary: _lightPrimary,
      secondary: _lightSecondary,
      background: _lightBackground,
      surface: _lightSurface,
      onPrimary: _lightOnPrimary,
      onSecondary: Colors.white,
      onBackground: const Color(0xFF1A1A2E),
      onSurface: const Color(0xFF1A1A2E),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _lightBackground,
      cardColor: _lightSurface,
      shadowColor: Colors.black12,

      // Typography — Poppins
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
            fontSize: 28, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A2E)),
        headlineMedium: GoogleFonts.poppins(
            fontSize: 22, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E)),
        titleLarge: GoogleFonts.poppins(
            fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E)),
        titleMedium: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1A1A2E)),
        bodyLarge: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFF333355)),
        bodyMedium: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF555577)),
        bodySmall: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF888899)),
        labelLarge: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, color: _lightOnPrimary),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: _lightSurface,
        foregroundColor: _lightPrimary,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1A2E),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A1A2E)),
      ),

      // Card
      cardTheme: CardTheme(
        color: _lightSurface,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: _lightOnPrimary,
          elevation: 2,
          shadowColor: _lightPrimary.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightPrimary,
          side: const BorderSide(color: _lightPrimary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimary,
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightPrimary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightPrimary.withOpacity(0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightPrimary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF9E9EBB)),
        labelStyle: GoogleFonts.poppins(fontSize: 14, color: _lightPrimary),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE8EAF6),
        thickness: 1,
        space: 1,
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _lightSurface,
        selectedItemColor: _lightPrimary,
        unselectedItemColor: Color(0xFF9E9EBB),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: _lightPrimary.withOpacity(0.08),
        labelStyle: GoogleFonts.poppins(fontSize: 12, color: _lightPrimary),
        side: BorderSide(color: _lightPrimary.withOpacity(0.2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ── Dark Theme ──────────────────────────────────────────────────────────────
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _darkPrimary,
      brightness: Brightness.dark,
      primary: _darkPrimary,
      secondary: _darkSecondary,
      background: _darkBackground,
      surface: _darkSurface,
      onPrimary: _darkOnPrimary,
      onSecondary: Colors.white,
      onBackground: const Color(0xFFE8EAFF),
      onSurface: const Color(0xFFE8EAFF),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _darkBackground,
      cardColor: _darkSurface,
      shadowColor: Colors.black54,

      // Typography — Poppins (dark)
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
            fontSize: 28, fontWeight: FontWeight.w700, color: const Color(0xFFE8EAFF)),
        headlineMedium: GoogleFonts.poppins(
            fontSize: 22, fontWeight: FontWeight.w600, color: const Color(0xFFE8EAFF)),
        titleLarge: GoogleFonts.poppins(
            fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFFE8EAFF)),
        titleMedium: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFFE8EAFF)),
        bodyLarge: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFFCCCEEE)),
        bodyMedium: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFFAAAACC)),
        bodySmall: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF7777AA)),
        labelLarge: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, color: _darkOnPrimary),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkPrimary,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFE8EAFF),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFE8EAFF)),
      ),

      // Card
      cardTheme: CardTheme(
        color: _darkSurface,
        elevation: 3,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: _darkOnPrimary,
          elevation: 2,
          shadowColor: _darkPrimary.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkPrimary,
          side: const BorderSide(color: _darkPrimary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimary,
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkPrimary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF3A3D55).withOpacity(0.8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkPrimary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF6B6B99)),
        labelStyle: GoogleFonts.poppins(fontSize: 14, color: _darkPrimary),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2D45),
        thickness: 1,
        space: 1,
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: _darkPrimary,
        unselectedItemColor: Color(0xFF5A5A88),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: _darkPrimary.withOpacity(0.12),
        labelStyle: GoogleFonts.poppins(fontSize: 12, color: _darkPrimary),
        side: BorderSide(color: _darkPrimary.withOpacity(0.25)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
