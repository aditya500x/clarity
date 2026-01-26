import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../config/constants.dart';

/// Session ID management - ONE responsibility
class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();
  
  final Uuid _uuid = const Uuid();
  String? _currentSessionId;
  
  /// Get current session ID, create if doesn't exist
  Future<String> getSessionId() async {
    if (_currentSessionId != null) {
      return _currentSessionId!;
    }
    
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(AppConstants.sessionIdKey);
    
    if (sessionId == null) {
      sessionId = _uuid.v4();
      await prefs.setString(AppConstants.sessionIdKey, sessionId);
    }
    
    _currentSessionId = sessionId;
    return sessionId;
  }
  
  /// Create a new session (for chatbot)
  Future<String> createNewSession() async {
    final sessionId = _uuid.v4();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.sessionIdKey, sessionId);
    _currentSessionId = sessionId;
    return sessionId;
  }
  
  /// Clear current session
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.sessionIdKey);
    _currentSessionId = null;
  }
}
