import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import 'task_output_screen.dart';

/// Screen for inputting task to be broken down
class TaskInputScreen extends StatefulWidget {
  const TaskInputScreen({super.key});

  @override
  State<TaskInputScreen> createState() => _TaskInputScreenState();
}

class _TaskInputScreenState extends State<TaskInputScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _handleBreakDownTask() {
    if (_taskController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a task first',
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
      );
      return;
    }

    // Navigate to output screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskOutputScreen(taskTitle: _taskController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Break Down a Task'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
          iconSize: 28,
          tooltip: 'Go back',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),

              // Instruction text
              Text(
                'Tell me about your task',
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.s),

              Text(
                'I\'ll help you break it into simple steps',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Task input field
              AppTextField(
                controller: _taskController,
                hint:
                    'Type your assignment here...\n\nFor example: "Write an essay on Ancient Rome"',
                maxLines: 8,
                minLines: 8,
                keyboardType: TextInputType.multiline,
              ),

              const SizedBox(height: AppSpacing.m),

              // Optional camera icon (disabled)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 20,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Photo upload coming soon',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Primary action button
              AppButton(
                text: 'Break This Into Steps',
                onPressed: _handleBreakDownTask,
                icon: Icons.auto_fix_high_rounded,
              ),

              const SizedBox(height: AppSpacing.m),
            ],
          ),
        ),
      ),
    );
  }
}
