import 'package:flutter/material.dart';
import 'colors.dart';

/// Theme configuration - cosmetic only (colors, no structural changes)
class AppThemes {
  static ThemeData getTheme(int themeIndex) {
    final colorScheme = AppColorScheme.allThemes[themeIndex % AppColorScheme.allThemes.length];
    
    return ThemeData(
      useMaterial3: true,
      
      // Color scheme
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: colorScheme.primary,
        onPrimary: Colors.white,
        secondary: colorScheme.secondary,
        onSecondary: Colors.white,
        error: Colors.red.shade400,
        onError: Colors.white,
        surface: colorScheme.surface,
        onSurface: colorScheme.textPrimary,
      ),
      
      scaffoldBackgroundColor: colorScheme.background,
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      
      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: colorScheme.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colorScheme.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: colorScheme.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: colorScheme.textSecondary,
        ),
      ),
      
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
