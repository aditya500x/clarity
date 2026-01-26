/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:8000';
  
  // API Endpoints (must match FastAPI backend routes)
  static const String taskerEndpoint = '/api/tasker/start';
  static const String paragraphEndpoint = '/api/reader/input';
  static const String chatbotEndpoint = '/api/chat/message';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 60.0;
  static const double iconSize = 32.0;
  
  // Input Method Types
  static const String inputMethodText = 'text';
  static const String inputMethodAudio = 'audio';
  static const String inputMethodImage = 'image';
  
  // Theme Keys
  static const String themePreferenceKey = 'selected_theme';
  static const String sessionIdKey = 'session_id';
  
  // Validation
  static const int minTaskLength = 5;
  static const int minParagraphLength = 10;
  static const int minChatMessageLength = 1;
}
