import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/markdown_renderer.dart';
import '../../services/api_service.dart';
import '../../models/chat_model.dart';
import '../../utils/helpers.dart';

/// Socratic Buddy chatbot screen (Module 3)
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
  
  @override
  void initState() {
    super.initState();
    // Add local greeting message
    _messages.add(
      ChatMessage(
        id: 'greeting',
        content: 'Hi! I\'m your Socratic Buddy. I\'m here to help you think through problems and learn by asking questions. What would you like to explore today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract UUID from route arguments
    if (_sessionId == null) {
      _sessionId = ModalRoute.of(context)!.settings.arguments as String?;
    }
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _sessionId == null) return;
    
    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: messageText,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    
    _messageController.clear();
    _scrollToBottom();
    
    try {
      final botMessage = await _apiService.sendChat(_sessionId!, messageText);
      
      if (mounted) {
        setState(() {
          _messages.add(botMessage);
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Helpers.formatErrorMessage(e)),
            backgroundColor: Colors.red,
          ),
        );
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
    return AppScaffold(
      title: 'Socratic Buddy',
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: deprecated_member_use
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start a conversation',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ask me anything!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator for bot response
                      if (index == _messages.length && _isLoading) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const LoadingIndicator(
                              isOverlay: false,
                            ),
                          ),
                        );
                      }
                      
                      final message = _messages[index];
                      return _MessageBubble(message: message);
                    },
                  ),
          ),
          
          // Input field
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  // ignore: deprecated_member_use
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  
  const _MessageBubble({required this.message});
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownRenderer(
              data: message.content,
              baseStyle: TextStyle(
                color: message.isUser
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Helpers.formatTimestamp(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                // ignore: deprecated_member_use
                color: message.isUser
                    ? Colors.white.withOpacity(0.7)
                    // ignore: deprecated_member_use
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
