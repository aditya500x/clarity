import 'package:flutter/material.dart';

/// Loading indicator widget - LOADING IS A STATE, NOT A SCREEN
class LoadingIndicator extends StatelessWidget {
  final bool isOverlay;
  final String? message;
  
  const LoadingIndicator({
    super.key,
    this.isOverlay = false,
    this.message,
  });
  
  @override
  Widget build(BuildContext context) {
    final indicator = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
    
    if (isOverlay) {
      return Container(
        color: const Color.fromRGBO(0, 0, 0, 0.3),
        child: Center(child: indicator),
      );
    }
    
    return Center(child: indicator);
  }
}
