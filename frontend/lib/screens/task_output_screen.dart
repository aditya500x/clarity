import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/step_checklist_card.dart';
import '../widgets/app_button.dart';

/// Model for a task step
class TaskStep {
  final String title;
  final String timeEstimate;
  bool isCompleted;

  TaskStep({
    required this.title,
    required this.timeEstimate,
    this.isCompleted = false,
  });
}

/// Screen showing deconstructed task with checklist
class TaskOutputScreen extends StatefulWidget {
  final String taskTitle;

  const TaskOutputScreen({super.key, required this.taskTitle});

  @override
  State<TaskOutputScreen> createState() => _TaskOutputScreenState();
}

class _TaskOutputScreenState extends State<TaskOutputScreen> {
  late List<TaskStep> steps;
  int currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    // Demo steps - in real app, these would come from backend/AI
    steps = _generateDemoSteps();
  }

  List<TaskStep> _generateDemoSteps() {
    return [
      TaskStep(
        title: 'Research the topic and gather key information',
        timeEstimate: '15 minutes',
      ),
      TaskStep(
        title: 'Create an outline with main points',
        timeEstimate: '10 minutes',
      ),
      TaskStep(
        title: 'Write the introduction paragraph',
        timeEstimate: '10 minutes',
      ),
      TaskStep(title: 'Write the body paragraphs', timeEstimate: '25 minutes'),
      TaskStep(title: 'Write the conclusion', timeEstimate: '10 minutes'),
      TaskStep(
        title: 'Review and edit for clarity',
        timeEstimate: '15 minutes',
      ),
    ];
  }

  double get progressPercentage {
    int completedCount = steps.where((step) => step.isCompleted).length;
    return completedCount / steps.length;
  }

  void _handleStepCheckChanged(int index, bool value) {
    setState(() {
      steps[index].isCompleted = value;

      // Move to next uncompleted step
      if (value) {
        for (int i = 0; i < steps.length; i++) {
          if (!steps[i].isCompleted) {
            currentStepIndex = i;
            break;
          }
        }

        // If all completed, show celebration
        if (steps.every((step) => step.isCompleted)) {
          _showCompletionDialog();
        }
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        title: Row(
          children: [
            const Icon(Icons.celebration_rounded, color: AppColors.success),
            const SizedBox(width: AppSpacing.s),
            Text('Great Job!', style: AppTextStyles.title),
          ],
        ),
        content: Text(
          'You\'ve completed all the steps! 🎉',
          style: AppTextStyles.body,
        ),
        actions: [
          AppButton(
            text: 'Done',
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            variant: AppButtonVariant.primary,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }

  void _handleReadAloud() {
    // Placeholder for text-to-speech functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Text-to-speech coming soon!',
          style: AppTextStyles.body.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Steps'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
          iconSize: 28,
          tooltip: 'Go back',
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progressPercentage,
            minHeight: 6,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),

          // Progress text
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              '${(progressPercentage * 100).toInt()}% Complete',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),

          // Task title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: Text(
              widget.taskTitle,
              style: AppTextStyles.headline,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.m),

          // Steps list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
              ),
              itemCount: steps.length,
              itemBuilder: (context, index) {
                return StepChecklistCard(
                  title: steps[index].title,
                  timeEstimate: steps[index].timeEstimate,
                  isCompleted: steps[index].isCompleted,
                  isCurrent:
                      index == currentStepIndex && !steps[index].isCompleted,
                  onCheckChanged: (value) =>
                      _handleStepCheckChanged(index, value),
                );
              },
            ),
          ),

          // Bottom sticky bar with Read Aloud button
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.overlay,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: AppButton(
                text: 'Read This Step Aloud',
                onPressed: _handleReadAloud,
                icon: Icons.volume_up_rounded,
                variant: AppButtonVariant.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
