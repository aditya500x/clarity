import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Markdown renderer widget for displaying formatted text
class MarkdownRenderer extends StatelessWidget {
  final String data;
  final TextStyle? baseStyle;
  
  const MarkdownRenderer({
    super.key,
    required this.data,
    this.baseStyle,
  });
  
  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: data,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      styleSheet: MarkdownStyleSheet(
        p: baseStyle ?? Theme.of(context).textTheme.bodyLarge,
        h1: Theme.of(context).textTheme.displayLarge,
        h2: Theme.of(context).textTheme.displayMedium,
        h3: Theme.of(context).textTheme.displaySmall,
        strong: (baseStyle ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        em: (baseStyle ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
          fontStyle: FontStyle.italic,
        ),
        listBullet: baseStyle ?? Theme.of(context).textTheme.bodyLarge,
        code: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontFamily: 'monospace',
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
