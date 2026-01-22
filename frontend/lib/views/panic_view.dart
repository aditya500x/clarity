import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/primary_button.dart';
import '../viewmodels/panic_viewmodel.dart';

/// Full-screen calming mode for overwhelming moments
class PanicView extends StatefulWidget {
  const PanicView({super.key});

  @override
  State<PanicView> createState() => _PanicViewState();
}

class _PanicViewState extends State<PanicView>
    with SingleTickerProviderStateMixin {
  final PanicViewModel _viewModel = PanicViewModel();
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  int _breathCount = 0;
  final int _totalBreaths = 3;

  @override
  void initState() {
    super.initState();

    // Breathing animation (4 seconds in, 4 seconds out)
    _breathingController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _breathCount++;
        });
        if (_breathCount < _totalBreaths) {
          _breathingController.reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });

    // Start breathing animation
    _breathingController.forward();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine breathing state for ViewModel text generation
    final bool isInhaling =
        _breathingController.status == AnimationStatus.forward ||
        _breathingController.value > 0.5;

    final String breathingText = _viewModel.getBreathingText(
      _breathCount,
      _totalBreaths,
      isInhaling,
    );

    return Scaffold(
      backgroundColor: AppColors.accentLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Breathing instruction
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  breathingText,
                  key: ValueKey(breathingText),
                  style: AppTextStyles.displayLarge.copyWith(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Breathing circle animation
              Center(
                child: AnimatedBuilder(
                  animation: _breathingAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _breathingAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.4),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Breath counter
              Center(
                child: Text(
                  '$_breathCount / $_totalBreaths breaths',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),

              // Continue button (appears after breathing)
              if (_breathCount >= _totalBreaths)
                AppButton(
                  text: "I'm Ready to Continue",
                  onPressed: () => Navigator.pop(context),
                  variant: AppButtonVariant.primary,
                ),

              const SizedBox(height: AppSpacing.m),

              // Exit early button
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
                child: Text(
                  'Exit',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
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
