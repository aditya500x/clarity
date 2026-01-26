import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../config/colors.dart';
import '../../services/api_service.dart';
import '../../models/chat_model.dart';
import '../../utils/helpers.dart';

/// Socratic Buddy chatbot screen (matches chat.html exactly)
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _apiService = ApiService();
  final List<ChatMessage> _messages = [];
  String? _sessionId;
  bool _isLoading = false;
  bool _isSending = false;
  
  @override
  void initState() {
    super.initState();
    _sessionId = const Uuid().v4();
    _loadGreeting();
  }
  
  Future<void> _loadGreeting() async {
    // Add initial greeting
    setState(() {
      _messages.add(
        ChatMessage(
          id: 'greeting',
          content: "Hi! I'm Buddy, your ADHD support companion. How can I help you today?",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _sessionId == null || _isSending) return;
    
    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: messageText,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    setState(() {
      _messages.add(userMessage);
      _isSending = true;
    });
    
    _messageController.clear();
    _scrollToBottom();
    
    try {
      final botMessage = await _apiService.sendChat(_sessionId!, messageText);
      
      if (mounted) {
        setState(() {
          _messages.add(botMessage);
          _isSending = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        // Add error message as AI response
        setState(() {
          _messages.add(
            ChatMessage(
              id: 'error-${DateTime.now().millisecondsSinceEpoch}',
              content: "I'm having trouble connecting to the server. Please check your connection.",
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    }
  }
  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.htmlTaskerBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Chat Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                itemCount: _messages.length + (_isSending ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isSending) {
                    return _buildTypingIndicator();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            
            // Input Area
            _buildInputArea(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.htmlTextMain,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Socratic Buddy',
            style: TextStyle(
              fontSize: 17.6,
              fontWeight: FontWeight.w600,
              color: AppColors.htmlTextMain,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: isUser 
              ? const Color(0xFF7B5EA1)  // accent-purple-dark
              : AppColors.htmlCardBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: isUser ? Radius.circular(16) : Radius.circular(4),
            bottomRight: isUser ? Radius.circular(4) : Radius.circular(16),
          ),
          border: isUser ? null : Border.all(
            color: Colors.black.withOpacity(0.03),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.content,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: isUser ? Colors.white : AppColors.htmlTextMain,
          ),
        ),
      ),
    );
  }
  
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text(
          'Buddy is thinking...',
          style: TextStyle(
            fontSize: 12.8,
            fontStyle: FontStyle.italic,
            color: AppColors.htmlTextSub,
          ),
        ),
      ),
    );
  }
  
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ask a question...',
                  hintStyle: TextStyle(color: AppColors.htmlTextSub),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.htmlTextMain,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _isSending ? null : _sendMessage,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF7B5EA1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
