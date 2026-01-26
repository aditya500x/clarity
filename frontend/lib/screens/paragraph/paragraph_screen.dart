import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/tab_input_widget.dart';
import '../../services/api_service.dart';
import '../../utils/helpers.dart';
import 'paragraph_result_screen.dart';

/// Sensory Safe Reader input screen (Module 2)
class ParagraphScreen extends StatefulWidget {
  const ParagraphScreen({super.key});
  
  @override
  State<ParagraphScreen> createState() => _ParagraphScreenState();
}

class _ParagraphScreenState extends State<ParagraphScreen> {
  final _apiService = ApiService();
  bool _isLoading = false;
  String? _sessionId;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract UUID from route arguments
    if (_sessionId == null) {
      _sessionId = ModalRoute.of(context)!.settings.arguments as String?;
    }
  }
  
  Future<void> _submitParagraph(String inputData, String inputMethod) async {
    if (_sessionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session ID not found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final result = await _apiService.sendParagraph(
        _sessionId!,
        inputData,
        inputMethod,
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParagraphResultScreen(result: result),
          ),
        );
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
  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sensory Safe Reader',
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Simplify complex text for easier reading',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              
              Expanded(
                child: TabInputWidget(
                  onSubmit: _submitParagraph,
                  textHint: 'Paste complex text here...',
                  textLabel: 'Enter text to simplify',
                  maxLines: 8,
                ),
              ),
            ],
          ),
          
          // Loading overlay
          if (_isLoading)
            const LoadingIndicator(
              isOverlay: true,
              message: 'Simplifying your text...',
            ),
        ],
      ),
    );
  }
}
