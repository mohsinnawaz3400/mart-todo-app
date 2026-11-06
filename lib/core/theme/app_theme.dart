import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

//LIGHT THEME

  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      scaffoldBackgroundColor: AppColors.background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.success,
        surface: AppColors.cardBackground,
      ),

      textTheme: baseTheme.textTheme.copyWith(
        bodyLarge: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
        titleLarge: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelLarge: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),

      floatingActionButtonTheme:
      const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 3,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );
  }

  // DARK THEME

  static ThemeData get darkTheme {
    const darkBackground = Color(0xFF111426);
    const darkCard = Color(0xFF1D2238);

    final baseTheme = ThemeData.dark();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      scaffoldBackgroundColor: darkBackground,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.success,
        surface: darkCard,
      ),

      textTheme: baseTheme.textTheme.copyWith(
        bodyLarge: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 12,
        ),
        titleLarge: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
