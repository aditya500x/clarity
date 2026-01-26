import 'package:flutter/material.dart';

/// Color schemes for the three themes
class AppColors {
  // Theme 1: Default (Mint & Cream) - LOCKED
  static const Color defaultPrimary = Color(0xFFA8D5BA); // Mint Green
  static const Color defaultSecondary = Color(0xFFB8C9E8); // Muted Blue
  static const Color defaultAccent = Color(0xFFE6D5F5); // Soft Lavender
  static const Color defaultBackground = Color(0xFFFBF7F0); // Warm Cream
  static const Color defaultSurface = Color(0xFFF5F0E8); // Light Cream
  static const Color defaultTextPrimary = Color(0xFF3D3D3D); // Soft Black
  static const Color defaultTextSecondary = Color(0xFF6B6B6B); // Medium Gray
  
  // Theme 2: Ocean (Cool Blues & Teals)
  static const Color oceanPrimary = Color(0xFF7EC8E3); // Sky Blue
  static const Color oceanSecondary = Color(0xFF5DADE2); // Ocean Blue
  static const Color oceanAccent = Color(0xFF85C1E2); // Light Blue
  static const Color oceanBackground = Color(0xFFF0F8FF); // Alice Blue
  static const Color oceanSurface = Color(0xFFE6F3F8); // Light Cyan
  static const Color oceanTextPrimary = Color(0xFF2C3E50); // Dark Blue Gray
  static const Color oceanTextSecondary = Color(0xFF5D6D7E); // Medium Blue Gray
  
  // Theme 3: Sunset (Warm Oranges & Purples)
  static const Color sunsetPrimary = Color(0xFFFFB347); // Pastel Orange
  static const Color sunsetSecondary = Color(0xFFFF8C94); // Coral Pink
  static const Color sunsetAccent = Color(0xFFD4A5D4); // Lavender Purple
  static const Color sunsetBackground = Color(0xFFFFF5E6); // Cream
  static const Color sunsetSurface = Color(0xFFFFEFDB); // Peach Cream
  static const Color sunsetTextPrimary = Color(0xFF4A3933); // Dark Brown
  static const Color sunsetTextSecondary = Color(0xFF7A6A5C); // Medium Brown
  
  // HTML-exact colors (from temp/*.html CSS variables)
  static const Color htmlBackground = Color(0xFFFFFFFF);
  static const Color htmlCardBg = Color(0xFFF8F6F0);
  static const Color htmlTextMain = Color(0xFF333333);
  static const Color htmlTextSub = Color(0xFF757575);
  static const Color htmlAccentPurple = Color(0xFFE9DEF5);
  static const Color htmlAccentGreen = Color(0xFF90C4A4);
  static const Color htmlIconGreenBg = Color(0xFFEEF7F0);
  static const Color htmlIconGreen = Color(0xFF90C4A4);
  static const Color htmlIconBlueBg = Color(0xFFE9F2F8);
  static const Color htmlIconBlue = Color(0xFF9EBED6);
  static const Color htmlIconPurpleBg = Color(0xFFF2F0F7);
  static const Color htmlIconPurple = Color(0xFFBCAED4);
  static const Color htmlTaskerBg = Color(0xFFFCFAF7);
}

/// Color scheme data for each theme
class AppColorScheme {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  
  const AppColorScheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
  });
  
  // Theme 0: Default
  static const AppColorScheme defaultTheme = AppColorScheme(
    primary: AppColors.defaultPrimary,
    secondary: AppColors.defaultSecondary,
    accent: AppColors.defaultAccent,
    background: AppColors.defaultBackground,
    surface: AppColors.defaultSurface,
    textPrimary: AppColors.defaultTextPrimary,
    textSecondary: AppColors.defaultTextSecondary,
  );
  
  // Theme 1: Ocean
  static const AppColorScheme oceanTheme = AppColorScheme(
    primary: AppColors.oceanPrimary,
    secondary: AppColors.oceanSecondary,
    accent: AppColors.oceanAccent,
    background: AppColors.oceanBackground,
    surface: AppColors.oceanSurface,
    textPrimary: AppColors.oceanTextPrimary,
    textSecondary: AppColors.oceanTextSecondary,
  );
  
  // Theme 2: Sunset
  static const AppColorScheme sunsetTheme = AppColorScheme(
    primary: AppColors.sunsetPrimary,
    secondary: AppColors.sunsetSecondary,
    accent: AppColors.sunsetAccent,
    background: AppColors.sunsetBackground,
    surface: AppColors.sunsetSurface,
    textPrimary: AppColors.sunsetTextPrimary,
    textSecondary: AppColors.sunsetTextSecondary,
  );
  
  // List of all themes
  static const List<AppColorScheme> allThemes = [
    defaultTheme,
    oceanTheme,
    sunsetTheme,
  ];
  
  static const List<String> themeNames = [
    'Default (Mint & Cream)',
    'Ocean (Cool Blues)',
    'Sunset (Warm Tones)',
  ];
}
