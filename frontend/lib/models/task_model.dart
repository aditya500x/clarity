/// Task Deconstructor data model - ALIGNED WITH BACKEND DB SCHEMA
class TaskResult {
  final String taskId;
  final String originalTask;
  final List<TaskStep> steps;
  
  TaskResult({
    required this.taskId,
    required this.originalTask,
    required this.steps,
  });
  
  factory TaskResult.fromJson(Map<String, dynamic> json) {
    return TaskResult(
      taskId: json['task_id'] ?? '',
      originalTask: json['original_task'] ?? json['input_data'] ?? '',
      steps: (json['steps'] as List<dynamic>?)
          ?.map((step) => TaskStep.fromJson(step))
          .toList() ?? [],
    );
  }
}

class TaskStep {
  final int stepIndex;      // matches DB: step_index
  final String stepText;    // matches DB: step_text
  final bool isCompleted;   // matches DB: is_completed
  final String status;      // matches DB: status
  
  TaskStep({
    required this.stepIndex,
    required this.stepText,
    required this.isCompleted,
    required this.status,
  });
  
  factory TaskStep.fromJson(Map<String, dynamic> json) {
    return TaskStep(
      stepIndex: json['step_index'] ?? 0,
      stepText: json['step_text'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      status: json['status'] ?? 'pending',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'step_index': stepIndex,
      'step_text': stepText,
      'is_completed': isCompleted,
      'status': status,
    };
  }
}
