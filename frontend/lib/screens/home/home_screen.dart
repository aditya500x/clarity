import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/big_action_button.dart';
import '../../services/session_service.dart';

/// Home screen - main landing page
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  Future<void> _navigateToModule(BuildContext context, String route) async {
    // Generate new UUID for this session
    final sessionService = SessionService();
    final uuid = await sessionService.createNewSession();
    
    // Navigate with UUID as argument
    if (context.mounted) {
      Navigator.pushNamed(context, route, arguments: uuid);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: false,
      showSettingsIcon: true,
      onSettingsTap: () {
        Navigator.pushNamed(context, '/settings');
      },
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome text
          Text(
            'CLARITY',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a tool to get started',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          
          // Module 1: Task Deconstructor
          BigActionButton(
            label: 'Task Deconstructor',
            iconPath: 'assets/icons/tasker.svg',
            onTap: () => _navigateToModule(context, '/tasker'),
          ),
          const SizedBox(height: 16),
          
          // Module 2: Sensory Safe Reader
          BigActionButton(
            label: 'Sensory Safe Reader',
            iconPath: 'assets/icons/paragraph.svg',
            onTap: () => _navigateToModule(context, '/paragraph'),
          ),
          const SizedBox(height: 16),
          
          // Module 3: Socratic Buddy
          BigActionButton(
            label: 'Socratic Buddy',
            iconPath: 'assets/icons/chatbot.svg',
            onTap: () => _navigateToModule(context, '/chatbot'),
          ),
        ],
      ),
    );
  }
}
