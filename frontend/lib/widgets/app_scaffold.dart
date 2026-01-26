import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config/constants.dart';

/// Consistent app layout wrapper
class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final bool showBackButton;
  final bool showSettingsIcon;
  final VoidCallback? onSettingsTap;
  
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.showBackButton = true,
    this.showSettingsIcon = false,
    this.onSettingsTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
        title: title != null
            ? Text(
                title!,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 20,
                ),
              )
            : null,
        actions: showSettingsIcon
            ? [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/settings.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: onSettingsTap,
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: body,
        ),
      ),
    );
  }
}
