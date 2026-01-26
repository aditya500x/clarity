import '../config/constants.dart';

/// Input validation functions
class Validators {
  /// Validate task input
  static String? validateTask(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a task';
    }
    if (value.trim().length < AppConstants.minTaskLength) {
      return 'Task must be at least ${AppConstants.minTaskLength} characters';
    }
    return null;
  }
  
  /// Validate paragraph input
  static String? validateParagraph(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter text to simplify';
    }
    if (value.trim().length < AppConstants.minParagraphLength) {
      return 'Text must be at least ${AppConstants.minParagraphLength} characters';
    }
    return null;
  }
  
  /// Validate chat message
  static String? validateChatMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a message';
    }
    if (value.trim().length < AppConstants.minChatMessageLength) {
      return 'Message cannot be empty';
    }
    return null;
  }
  
  /// Check if string is not empty
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}
