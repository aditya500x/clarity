/// Consistent spacing system based on 8px grid
class AppSpacing {
  AppSpacing._(); // Private constructor

  // Spacing scale
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Tap targets (larger than standard for accessibility)
  static const double minTapTarget = 48.0;
  static const double recommendedTapTarget = 56.0;

  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;

  // Padding presets
  static const double screenPaddingHorizontal = m;
  static const double screenPaddingVertical = l;
  static const double cardPadding = l;
  static const double buttonPadding = m;
}
