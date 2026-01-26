import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/big_action_button.dart';
import '../tasker/tasker_screen.dart';
import '../paragraph/paragraph_screen.dart';
import '../chatbot/chatbot_screen.dart';
import '../settings/settings_screen.dart';

/// Home screen - main landing page
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: false,
      showSettingsIcon: true,
      onSettingsTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskerScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // Module 2: Sensory Safe Reader
          BigActionButton(
            label: 'Sensory Safe Reader',
            iconPath: 'assets/icons/paragraph.svg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParagraphScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // Module 3: Socratic Buddy
          BigActionButton(
            label: 'Socratic Buddy',
            iconPath: 'assets/icons/chatbot.svg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatbotScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
