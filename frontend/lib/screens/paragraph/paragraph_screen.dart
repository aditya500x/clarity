import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/loading_indicator.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';
import '../../config/constants.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';
import 'paragraph_result_screen.dart';

/// Sensory Safe Reader input screen (Module 2)
class ParagraphScreen extends StatefulWidget {
  const ParagraphScreen({super.key});
  
  @override
  State<ParagraphScreen> createState() => _ParagraphScreenState();
}

class _ParagraphScreenState extends State<ParagraphScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _apiService = ApiService();
  final _sessionService = SessionService();
  bool _isLoading = false;
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  Future<void> _submitParagraph() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final sessionId = await _sessionService.getSessionId();
      final result = await _apiService.sendParagraph(
        sessionId,
        _textController.text.trim(),
        AppConstants.inputMethodParagraph,
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
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Simplify complex text for easier reading',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                
                TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'Enter text to simplify',
                    hintText: 'Paste complex text here...',
                    helperText: '${_textController.text.length} characters',
                  ),
                  maxLines: 8,
                  validator: Validators.validateParagraph,
                  enabled: !_isLoading,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitParagraph,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Simplify Text'),
                ),
              ],
            ),
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
