import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Gamified task step card with checkbox and time estimate
/// Visually emphasizes current step
class StepChecklistCard extends StatefulWidget {
  final String title;
  final String timeEstimate;
  final bool isCompleted;
  final bool isCurrent;
  final Function(bool) onCheckChanged;

  const StepChecklistCard({
    super.key,
    required this.title,
    required this.timeEstimate,
    required this.isCompleted,
    required this.isCurrent,
    required this.onCheckChanged,
  });

  @override
  State<StepChecklistCard> createState() => _StepChecklistCardState();
}

class _StepChecklistCardState extends State<StepChecklistCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleCheckChange(bool? value) {
    if (value != null) {
      _controller.forward().then((_) => _controller.reverse());
      widget.onCheckChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        color: widget.isCurrent ? AppColors.primaryLight : AppColors.surface,
        elevation: widget.isCurrent ? 2 : 0,
        margin: const EdgeInsets.only(bottom: AppSpacing.m),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          side: BorderSide(
            color: widget.isCurrent ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            children: [
              // Large checkbox
              Transform.scale(
                scale: 1.3,
                child: Checkbox(
                  value: widget.isCompleted,
                  onChanged: widget.isCurrent ? _handleCheckChange : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
              ),

              const SizedBox(width: AppSpacing.m),

              // Step content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: widget.isCurrent
                            ? FontWeight.w600
                            : FontWeight.w400,
                        decoration: widget.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: widget.isCompleted
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          widget.timeEstimate,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Current step indicator
              if (widget.isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: Text(
                    'Current',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
