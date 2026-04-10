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
  static const errorRed = Color(0xFFDC2626);
  static const disabledGrey = Color(0xFF9CA3AF);
}

class AppTextStyles {
  // ===== Headings =====
  /// Очень большой заголовок (экраны авторизации, большие секции)
  static const displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Большой заголовок (экраны, основные заголовки)
  static const headingXL = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Заголовок большой (карточки, секции)
  static const headingLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Заголовок средний (подзаголовки, карточки)
  static const headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Заголовок малый (секции, таблицы)
  static const headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Подзаголовок (описания, небольшие секции)
  static const subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ===== Body Text =====
  /// Основной текст большой
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// Основной текст средний
  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  /// Основной текст малый
  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // ===== Labels & Descriptions =====
  /// Ярлык (теги, чипсы, бейджи)
  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Ярлык средний (элементы интерфейса)
  static const labelMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Ярлык малый (значки, иконки)
  static const labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Описание текста (основные описания)
  static const captionLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Описание текста (вспомогательная информация)
  static const captionMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Хинт текст (плейсхолдеры)
  static const hint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ===== Special Styles =====
  /// Стиль для кнопок
  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// Стиль для кнопок в AppBar
  static const appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// Белый текст большой (на цветных фонах)
  static const whiteHeadingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// Белый текст средний (подзаголовки)
  static const whiteHeadingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// Белый подсказывающий текст
  static const whiteCaption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE5E7EB),
  );

  /// Белый текст для имени на цветных фонах
  static const whiteBodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// Белый полупрозрачный текст
  static const whiteSubtle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );

  /// Статистика (числа)
  static const statNumber = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Статистика (заголовок)
  static const statLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Тег/Чип (малые элементы со стилем)
  static const tag = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlue,
  );

  /// Ошибка
  static const errorText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.errorRed,
    height: 1.2,
  );

  /// Информация/помощь
  static const infoText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
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
        titleTextStyle: AppTextStyles.appBarTitle,
      ),
    );
  }
}
