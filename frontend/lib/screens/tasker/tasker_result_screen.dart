import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/markdown_renderer.dart';
import '../../models/task_model.dart';

/// Task Deconstructor result screen
class TaskerResultScreen extends StatelessWidget {
  final TaskResult result;
  
  const TaskerResultScreen({
    super.key,
    required this.result,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Task Breakdown',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Original task
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Original Task',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  MarkdownRenderer(
                    data: result.originalTask,
                    baseStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Steps header
          Text(
            'Steps to Complete',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          
          // Steps list
          Expanded(
            child: ListView.builder(
              itemCount: result.steps.length,
              itemBuilder: (context, index) {
                final step = result.steps[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        '${step.stepIndex}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: MarkdownRenderer(
                      data: step.stepText,
                      baseStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      'Status: ${step.status}',
                      style: TextStyle(
                        color: step.isCompleted
                            ? Colors.green
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    trailing: step.isCompleted
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Done button
          ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
