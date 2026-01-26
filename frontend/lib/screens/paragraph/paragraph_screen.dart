import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../services/api_service.dart';
import '../../utils/helpers.dart';
import 'paragraph_result_screen.dart';

/// Sensory Safe Reader input screen (matches lib.examples style)
class ParagraphScreen extends StatefulWidget {
  const ParagraphScreen({super.key});
  
  @override
  State<ParagraphScreen> createState() => _ParagraphScreenState();
}

enum InputMethod { text, audio, photo }

class _ParagraphScreenState extends State<ParagraphScreen> {
  final _apiService = ApiService();
  final _textController = TextEditingController();
  bool _isLoading = false;
  InputMethod _selectedMethod = InputMethod.text;
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  Future<void> _submitParagraph() async {
    if (_textController.text.trim().isEmpty) {
      _showToast('Please enter some text first');
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final result = await _apiService.sendParagraph(
        _textController.text.trim(),
        'text',
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
        _showToast(Helpers.formatErrorMessage(e));
      }
    }
  }
  
  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFF4A4A4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF7F0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.htmlTextMain, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sensory-Safe Reader',
          style: TextStyle(
            color: AppColors.htmlTextMain,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Method Selector
            _buildInputSelector(),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(child: _buildInputContent()),
                    const SizedBox(height: 16),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInputSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildInputTab(
            icon: Icons.keyboard_rounded,
            label: 'Text',
            isSelected: _selectedMethod == InputMethod.text,
            onTap: () => setState(() => _selectedMethod = InputMethod.text),
          ),
          const SizedBox(width: 8),
          _buildInputTab(
            icon: Icons.mic_rounded,
            label: 'Voice',
            isSelected: _selectedMethod == InputMethod.audio,
            onTap: () => _showToast('Voice input coming soon!'),
          ),
          const SizedBox(width: 8),
          _buildInputTab(
            icon: Icons.camera_alt_rounded,
            label: 'Photo',
            isSelected: _selectedMethod == InputMethod.photo,
            onTap: () => _showToast('Photo input coming soon!'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInputTab({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Use blue accent for paragraph module
    final accentColor = const Color(0xFF9EBED6);
    
    return Expanded(
      child: Material(
        color: isSelected ? accentColor : const Color(0xFFF5F0E8),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? accentColor : const Color(0xFFD6CFC3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? Colors.white : AppColors.htmlTextMain,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.htmlTextMain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInputContent() {
    return TextField(
      controller: _textController,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        fontSize: 16,
        color: AppColors.htmlTextMain,
        height: 1.6,
      ),
      decoration: InputDecoration(
        hintText: "Paste any text or topic here, and we'll explain it in a calm, easy-to-understand way.",
        hintStyle: TextStyle(
          fontSize: 16,
          color: const Color(0xFF999999),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F0E8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFFD6CFC3), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFFD6CFC3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFF9EBED6), width: 2),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
  
  Widget _buildSubmitButton() {
    final accentColor = const Color(0xFF9EBED6);
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitParagraph,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: const Color(0xFF2C2C2C),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            else ...[
              Icon(Icons.auto_awesome_rounded, size: 20),
              const SizedBox(width: 8),
              Text(
                'Simplify Text',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
