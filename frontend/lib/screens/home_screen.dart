import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_card.dart';
import '../widgets/panic_button.dart';
import 'task_input_screen.dart';
import 'panic_mode_screen.dart';

/// Home screen with main navigation options
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Text(
                'What do you want help with today?',
                style: AppTextStyles.displayMedium,
                textAlign: TextAlign.center,
              ),
            ),

            // Scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPaddingHorizontal,
                ),
                children: [
                  const SizedBox(height: AppSpacing.m),

                  // Break Down a Task
                  AppCard(
                    icon: Icons.checklist_rounded,
                    title: 'Break Down a Task',
                    description:
                        'Turn big assignments into small, manageable steps',
                    iconColor: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TaskInputScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.m),

                  // Read Safely
                  AppCard(
                    icon: Icons.auto_stories_rounded,
                    title: 'Read Safely',
                    description:
                        'Sensory-friendly reading with customizable settings',
                    iconColor: AppColors.secondary,
                    onTap: () {
                      _showComingSoonDialog(context, 'Sensory-Safe Reader');
                    },
                  ),

                  const SizedBox(height: AppSpacing.m),

                  // Ask a Tutor
                  AppCard(
                    icon: Icons.chat_rounded,
                    title: 'Socratic Buddy',
                    description:
                        'Get step-by-step help through guided questions',
                    iconColor: AppColors.accent,
                    onTap: () {
                      _showComingSoonDialog(context, 'Socratic Buddy');
                    },
                  ),

                  // Bottom spacing to prevent overlap with panic button
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),

            // Panic button (fixed at bottom)
            PanicButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PanicModeScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        title: Text('Coming Soon', style: AppTextStyles.title),
        content: Text(
          '$feature is currently under development. Stay tuned!',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
