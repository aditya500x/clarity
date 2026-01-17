import 'package:flutter/material.dart';

/// Centralized color palette for Clarity app
/// Soft pastel theme designed for neurodivergent users
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary colors - Mint Green
  static const Color primary = Color(0xFFA8D5BA);
  static const Color primaryLight = Color(0xFFCFE9D9);
  static const Color primaryDark = Color(0xFF89C0A3);

  // Secondary colors - Muted Blue
  static const Color secondary = Color(0xFFB8C9E8);
  static const Color secondaryLight = Color(0xFFD4DFF3);
  static const Color secondaryDark = Color(0xFF9BB3DC);

  // Accent colors - Soft Lavender
  static const Color accent = Color(0xFFE6D5F5);
  static const Color accentLight = Color(0xFFF2E8F9);
  static const Color accentDark = Color(0xFFD4BEEB);

  // Background colors - Warm Cream
  static const Color background = Color(0xFFFBF7F0);
  static const Color surface = Color(0xFFF5F0E8);
  static const Color surfaceVariant = Color(0xFFEFE8DC);

  // Semantic colors
  static const Color error = Color(0xFFF4A4A4);
  static const Color errorLight = Color(0xFFF9CFCF);
  static const Color success = Color(0xFFB8E6B8);
  static const Color warning = Color(0xFFFAD4A0);

  // Text colors - High contrast but not harsh
  static const Color textPrimary = Color(0xFF3D3D3D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textOnPrimary = Color(0xFF2C2C2C);

  // Divider and border colors
  static const Color divider = Color(0xFFE0D8CC);
  static const Color border = Color(0xFFD6CFC3);

  // Overlay colors
  static const Color overlay = Color(0x1A000000); // 10% black
  static const Color scrim = Color(0x99000000); // 60% black
}
