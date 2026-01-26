import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../services/theme_service.dart';
import '../../config/colors.dart';

/// Settings screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _themeService = ThemeService();
  int _selectedTheme = 0;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }
  
  Future<void> _loadTheme() async {
    final theme = await _themeService.loadTheme();
    setState(() {
      _selectedTheme = theme;
      _isLoading = false;
    });
  }
  
  Future<void> _saveTheme(int themeIndex) async {
    await _themeService.saveTheme(themeIndex);
    setState(() => _selectedTheme = themeIndex);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Theme updated! Restart the app to see changes.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Settings',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Theme selection section
                Text(
                  'Theme',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose your preferred color theme',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        
                        // Theme options
                        ...List.generate(
                          AppColorScheme.allThemes.length,
                          (index) => RadioListTile<int>(
                            value: index,
                            groupValue: _selectedTheme,
                            onChanged: (value) {
                              if (value != null) {
                                _saveTheme(value);
                              }
                            },
                            title: Text(AppColorScheme.themeNames[index]),
                            subtitle: _ThemePreview(
                              colorScheme: AppColorScheme.allThemes[index],
                            ),
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // About section
                Text(
                  'About',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CLARITY',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'An ADHD support application with three core modules:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Task Deconstructor\n• Sensory Safe Reader\n• Socratic Buddy',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Version 1.0.0',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            // ignore: deprecated_member_use
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ThemePreview extends StatelessWidget {
  final AppColorScheme colorScheme;
  
  const _ThemePreview({required this.colorScheme});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          _ColorCircle(color: colorScheme.primary),
          const SizedBox(width: 8),
          _ColorCircle(color: colorScheme.secondary),
          const SizedBox(width: 8),
          _ColorCircle(color: colorScheme.accent),
          const SizedBox(width: 8),
          _ColorCircle(color: colorScheme.background),
        ],
      ),
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  
  const _ColorCircle({required this.color});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
    );
  }
}
