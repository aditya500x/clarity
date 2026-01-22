import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/step_checklist_card.dart';
import '../widgets/primary_button.dart';
import '../viewmodels/task_steps_viewmodel.dart';

/// Screen showing deconstructed task with checklist
class TaskStepsView extends StatefulWidget {
  final String taskTitle;

  const TaskStepsView({super.key, required this.taskTitle});

  @override
  State<TaskStepsView> createState() => _TaskStepsViewState();
}

class _TaskStepsViewState extends State<TaskStepsView> {
  final TaskStepsViewModel _viewModel = TaskStepsViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadSteps(widget.taskTitle);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
    _viewModel.speakCurrentStep();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reading upcoming step...',
          style: AppTextStyles.body.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, child) {
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
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Progress bar
                    LinearProgressIndicator(
                      value: _viewModel.progressPercentage,
                      minHeight: 6,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),

                    // Progress text
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: Text(
                        '${(_viewModel.progressPercentage * 100).toInt()}% Complete',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    // Task title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                      ),
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
                        itemCount: _viewModel.steps.length,
                        itemBuilder: (context, index) {
                          final step = _viewModel.steps[index];
                          return StepChecklistCard(
                            title: step.title,
                            timeEstimate: step.timeEstimate,
                            isCompleted: step.isCompleted,
                            isCurrent:
                                index == _viewModel.currentStepIndex &&
                                !step.isCompleted,
                            onCheckChanged: (value) {
                              _viewModel.toggleStep(index, value);
                              if (_viewModel.allStepsCompleted) {
                                // Defer dialog to next frame
                                Future.delayed(
                                  Duration.zero,
                                  _showCompletionDialog,
                                );
                              }
                            },
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
      },
    );
  }
}
