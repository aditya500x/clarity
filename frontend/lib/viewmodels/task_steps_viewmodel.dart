import 'package:flutter/material.dart';
import '../models/task_step.dart';
import '../services/gemini_service.dart';
import '../services/tts_service.dart';

class TaskStepsViewModel extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final TtsService _ttsService = TtsService();

  List<TaskStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isLoading = true;

  List<TaskStep> get steps => _steps;
  int get currentStepIndex => _currentStepIndex;
  bool get isLoading => _isLoading;

  double get progressPercentage {
    if (_steps.isEmpty) return 0.0;
    int completedCount = _steps.where((step) => step.isCompleted).length;
    return completedCount / _steps.length;
  }

  Future<void> loadSteps(String taskTitle) async {
    _isLoading = true;
    notifyListeners();

    try {
      _steps = await _geminiService.generateSteps(taskTitle);
    } catch (e) {
      // Handle error
      debugPrint('Error loading steps: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleStep(int index, bool value) {
    _steps[index].isCompleted = value;

    if (value) {
      // Find next uncompleted step
      for (int i = 0; i < _steps.length; i++) {
        if (!_steps[i].isCompleted) {
          _currentStepIndex = i;
          break;
        }
      }
    }

    notifyListeners();
  }

  bool get allStepsCompleted => _steps.every((step) => step.isCompleted);

  Future<void> speakCurrentStep() async {
    // Logic to find what to speak
    if (_steps.isNotEmpty && _currentStepIndex < _steps.length) {
      await _ttsService.speak(_steps[_currentStepIndex].title);
    }
  }
}
