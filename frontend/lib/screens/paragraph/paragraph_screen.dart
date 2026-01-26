import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../services/api_service.dart';
import '../../utils/helpers.dart';
import 'paragraph_result_screen.dart';

/// Sensory Safe Reader input screen (matches input.html exactly)
class ParagraphScreen extends StatefulWidget {
  const ParagraphScreen({super.key});
  
  @override
  State<ParagraphScreen> createState() => _ParagraphScreenState();
}

class _ParagraphScreenState extends State<ParagraphScreen> {
  final _apiService = ApiService();
  final _textController = TextEditingController();
  bool _isLoading = false;
  bool _showBottomSheet = false;
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  Future<void> _submitParagraph() async {
    if (_textController.text.trim().isEmpty) return;
    
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
        content: Text(message),
        backgroundColor: AppColors.htmlTextMain,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.htmlBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Add Input Button
                    _buildAddInputButton(),
                    const SizedBox(height: 16),
                    
                    // Input Box (expands)
                    Expanded(
                      child: _buildInputBox(),
                    ),
                    const SizedBox(height: 16),
                    
                    // Analyze Button
                    _buildAnalyzeButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Sheet Overlay
      bottomSheet: _showBottomSheet ? _buildBottomSheet() : null,
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
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
            'Sensory-Safe Reading',
            style: TextStyle(
              fontSize: 17.6,
              fontWeight: FontWeight.w500,
              color: AppColors.htmlTextMain,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAddInputButton() {
    return GestureDetector(
      onTap: () => setState(() => _showBottomSheet = true),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFCFCFC),
          border: Border.all(color: AppColors.htmlAccentGreen, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: AppColors.htmlAccentGreen,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Add Input',
              style: TextStyle(
                fontSize: 14.4,
                color: AppColors.htmlTextSub,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInputBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EA),
        border: Border.all(color: AppColors.htmlAccentGreen, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _textController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: "Paste any text or topic here, and we'll explain it in a calm, easy-to-understand way.",
          hintStyle: TextStyle(color: const Color(0xFFB0B0B0)),
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 16,
          color: AppColors.htmlTextMain,
          height: 1.6,
        ),
      ),
    );
  }
  
  Widget _buildAnalyzeButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _submitParagraph,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.htmlAccentGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, color: const Color(0xFF2D2D2D), size: 18),
            const SizedBox(width: 8),
            Text(
              _isLoading ? 'Analyzing...' : 'Analyze Topic',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D2D2D),
              ),
            ),
            if (_isLoading) ...[
              const SizedBox(width: 12),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomSheet() {
    return GestureDetector(
      onTap: () => setState(() => _showBottomSheet = false),
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFCFAF7),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 40,
                  offset: Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0DDD7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Choose Input Method',
                  style: TextStyle(
                    fontSize: 17.6,
                    fontWeight: FontWeight.w700,
                    color: AppColors.htmlTextMain,
                  ),
                ),
                const SizedBox(height: 24),
                _buildMethodItem(
                  icon: Icons.keyboard,
                  title: 'Text Input',
                  subtitle: 'Type or paste text',
                  onTap: () {
                    setState(() => _showBottomSheet = false);
                  },
                ),
                _buildMethodItem(
                  icon: Icons.mic,
                  title: 'Audio Recording',
                  subtitle: 'Record voice note',
                  onTap: () => _showToast('Coming soon!'),
                ),
                _buildMethodItem(
                  icon: Icons.camera_alt,
                  title: 'Photo Upload',
                  subtitle: 'Camera or gallery',
                  onTap: () => _showToast('Coming soon!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMethodItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE1F0E4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.htmlAccentGreen, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.htmlTextMain,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.8,
                      color: AppColors.htmlTextSub,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '›',
              style: TextStyle(
                fontSize: 19.2,
                color: const Color(0xFFB5B5B5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
