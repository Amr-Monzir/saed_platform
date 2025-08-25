import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF5B6CFF);
  static const Color secondary = Color(0xFF00C2A8);
  static const Color accent = Color(0xFFFF7A59);
  static const Color surface = Color(0xFFF7F8FA);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

ThemeData buildLightTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    useMaterial3: true,
  );

  final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
    headlineMedium: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
    titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    bodyMedium: GoogleFonts.inter(color: AppColors.textSecondary),
    labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
  );

  final elevated = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  final outlined = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary, width: 1.2),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  final input = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    labelStyle: const TextStyle(color: AppColors.textSecondary),
  );

  final chip = ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    selectedColor: AppColors.primary.withValues(alpha: .12),
    backgroundColor: Colors.white,
    labelStyle: const TextStyle(color: AppColors.textSecondary),
    secondaryLabelStyle: const TextStyle(color: AppColors.textPrimary),
    side: const BorderSide(color: Color(0xFFE2E8F0)),
  );

  final appBar = base.appBarTheme.copyWith(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
  );

  final cardTheme = CardThemeData(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
  );

  return base.copyWith(
    textTheme: textTheme,
    elevatedButtonTheme: elevated,
    outlinedButtonTheme: outlined,
    inputDecorationTheme: input,
    chipTheme: chip,
    appBarTheme: appBar,
    cardTheme: cardTheme,
    listTileTheme: const ListTileThemeData(iconColor: AppColors.textSecondary),
    dividerColor: const Color(0xFFE2E8F0),
    iconTheme: const IconThemeData(color: AppColors.textSecondary),
  );
}

ThemeData buildDarkTheme() {
  const darkSurface = Color(0xFF0B1220);
  const darkCard = Color(0xFF111A2B);
  const darkBorder = Color(0xFF243247);
  final base = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: darkSurface,
    ),
    scaffoldBackgroundColor: darkSurface,
    useMaterial3: true,
  );

  final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
    headlineMedium: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white),
    titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
    bodyMedium: GoogleFonts.inter(color: const Color(0xFFB6C2D2)),
    labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
  );

  final elevated = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  final outlined = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary, width: 1.2),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  final input = InputDecorationTheme(
    filled: true,
    fillColor: darkCard,
    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: darkBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: darkBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    labelStyle: const TextStyle(color: Color(0xFFB6C2D2)),
  );

  final chip = ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    selectedColor: AppColors.primary.withValues(alpha: .18),
    backgroundColor: darkCard,
    labelStyle: const TextStyle(color: Color(0xFFB6C2D2)),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    side: const BorderSide(color: Color(0xFF243247)),
  );

  final appBar = base.appBarTheme.copyWith(
    backgroundColor: darkCard,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
  );

  final cardTheme = CardThemeData(
    color: darkCard,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
  );

  return base.copyWith(
    textTheme: textTheme,
    elevatedButtonTheme: elevated,
    outlinedButtonTheme: outlined,
    inputDecorationTheme: input,
    chipTheme: chip,
    appBarTheme: appBar,
    cardTheme: cardTheme,
    listTileTheme: const ListTileThemeData(iconColor: Color(0xFFB6C2D2)),
    dividerColor: const Color(0xFF243247),
    iconTheme: const IconThemeData(color: Color(0xFFB6C2D2)),
  );
}


