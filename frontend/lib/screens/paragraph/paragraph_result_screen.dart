import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../models/paragraph_model.dart';

/// Sensory Safe Reader result screen
class ParagraphResultScreen extends StatefulWidget {
  final ParagraphResult result;
  
  const ParagraphResultScreen({
    super.key,
    required this.result,
  });
  
  @override
  State<ParagraphResultScreen> createState() => _ParagraphResultScreenState();
}

class _ParagraphResultScreenState extends State<ParagraphResultScreen> {
  bool _showOriginal = false;
  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Simplified Text',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toggle to show original
          Card(
            child: InkWell(
              onTap: () => setState(() => _showOriginal = !_showOriginal),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _showOriginal ? 'Original Text' : 'Show Original Text',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      _showOriginal
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Original text (collapsible)
          if (_showOriginal) ...[
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.result.originalText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Simplified text header
          Text(
            'Simplified Version',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          
          // Simplified text
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.result.simplifiedText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Key points (if available)
          if (widget.result.keyPoints != null &&
              widget.result.keyPoints!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Key Points',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.result.keyPoints!
                      .map((point) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                Expanded(
                                  child: Text(
                                    point,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Try Another'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  ),
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
