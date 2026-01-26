import 'package:flutter/material.dart';
import 'config/themes.dart';
import 'services/theme_service.dart';
import 'screens/home/home_screen.dart';

/// Root application widget
class ClarityApp extends StatefulWidget {
  const ClarityApp({super.key});
  
  @override
  State<ClarityApp> createState() => _ClarityAppState();
}

class _ClarityAppState extends State<ClarityApp> {
  final _themeService = ThemeService();
  int _currentTheme = 0;
  
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }
  
  Future<void> _loadTheme() async {
    final theme = await _themeService.loadTheme();
    setState(() => _currentTheme = theme);
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLARITY',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.getTheme(_currentTheme),
      home: const HomeScreen(),
    );
  }
}
