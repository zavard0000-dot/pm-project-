import 'package:flutter/material.dart';

// ==========================================
// 📂 theme/app_theme.dart
// ==========================================
class AppColors {
  static const primaryBlue = Color(0xFF2563EB);
  static const primaryPurple = Color(0xFF7C3AED);
  static const accentPink = Color(0xFFDB2777);
  static const background = Color(0xFFF9FAFB);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const inputBorder = Color(0xFFE5E7EB);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        primary: AppColors.primaryBlue,
        background: AppColors.background,
      ),
      fontFamily: 'Roboto', // Replace with 'Inter' in pubspec.yaml if desired
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
