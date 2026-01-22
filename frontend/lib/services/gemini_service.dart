import '../models/task_step.dart';

class GeminiService {
  Future<List<TaskStep>> generateSteps(String taskDescription) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Demo data for now
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
}
