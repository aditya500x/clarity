import 'package:flutter/material.dart';
import 'config/themes.dart';
import 'services/theme_service.dart';
import 'screens/home/home_screen.dart';
import 'screens/tasker/tasker_screen.dart';
import 'screens/paragraph/paragraph_screen.dart';
import 'screens/chatbot/chatbot_screen.dart';
import 'screens/settings/settings_screen.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/tasker': (context) => const TaskerScreen(),
        '/paragraph': (context) => const ParagraphScreen(),
        '/chatbot': (context) => const ChatbotScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
