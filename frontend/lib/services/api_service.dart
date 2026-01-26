import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/task_model.dart';
import '../models/paragraph_model.dart';
import '../models/chat_model.dart';

/// HTTP client service - ALL HTTP calls only. One responsibility.
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();
  
  final String _baseUrl = AppConstants.apiBaseUrl;
  
  /// Send task to Task Deconstructor (Module 1)
  Future<TaskResult> sendTask(
    String sessionId,
    String inputData,
    String inputMethod,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${AppConstants.taskerEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'session_id': sessionId,
          'input_method': inputMethod,
          'input_data': inputData,
        }),
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TaskResult.fromJson(data);
      } else {
        throw Exception('Failed to process task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending task: $e');
    }
  }
  
  /// Send paragraph to Sensory Safe Reader (Module 2)
  Future<ParagraphResult> sendParagraph(
    String sessionId,
    String inputData,
    String inputMethod,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${AppConstants.paragraphEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'session_id': sessionId,
          'input_method': inputMethod,
          'input_data': inputData,
        }),
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ParagraphResult.fromJson(data);
      } else {
        throw Exception('Failed to process paragraph: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending paragraph: $e');
    }
  }
  
  /// Send chat message to Socratic Buddy (Module 3)
  Future<ChatMessage> sendChat(
    String sessionId,
    String message,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${AppConstants.chatbotEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'session_id': sessionId,
          'message': message,
        }),
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatMessage.fromJson(data, isUser: false);
      } else {
        throw Exception('Failed to send chat message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending chat: $e');
    }
  }
}
