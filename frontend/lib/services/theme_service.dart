import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

/// Theme persistence - ONE responsibility
class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();
  
  /// Save selected theme index
  Future<void> saveTheme(int themeIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.themePreferenceKey, themeIndex);
  }
  
  /// Load selected theme index (default: 0)
  Future<int> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.themePreferenceKey) ?? 0;
  }
}
