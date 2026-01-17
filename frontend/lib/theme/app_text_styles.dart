import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography system for Clarity app
/// Large, readable fonts with increased line height and letter spacing
class AppTextStyles {
  AppTextStyles._(); // Private constructor

  // Font family (can be switched to OpenDyslexic)
  static const String defaultFontFamily = 'System';
  static const String dyslexicFontFamily = 'OpenDyslexic';

  // Display styles - For main headers
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // Headline - For section headers
  static const TextStyle headline = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // Title - For card titles
  static const TextStyle title = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // Body styles - For main content
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  // Label - For buttons and labels
  static const TextStyle label = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // Caption - For helper text
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // Helper method to apply font family
  static TextStyle withFontFamily(
    TextStyle style, {
    bool useDyslexicFont = false,
  }) {
    return style.copyWith(
      fontFamily: useDyslexicFont ? dyslexicFontFamily : defaultFontFamily,
    );
  }
}
