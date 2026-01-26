/// Socratic Buddy chatbot data model
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  
  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
  
  factory ChatMessage.fromJson(Map<String, dynamic> json, {required bool isUser}) {
    return ChatMessage(
      id: json['message_id'] ?? json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['reply'] ?? json['content'] ?? json['message'] ?? '',
      isUser: isUser,
      timestamp: DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class ChatSession {
  final String sessionId;
  final List<ChatMessage> messages;
  
  ChatSession({
    required this.sessionId,
    required this.messages,
  });
}
