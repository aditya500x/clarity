import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../models/paragraph_model.dart';

/// Sensory Safe Reader result screen (matches paragraph.html exactly)
class ParagraphResultScreen extends StatefulWidget {
  final ParagraphResult result;
  
  const ParagraphResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<ParagraphResultScreen> createState() => _ParagraphResultScreenState();
}

class _ParagraphResultScreenState extends State<ParagraphResultScreen> {
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.htmlTaskerBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildContentCard(),
              ),
            ),
            
            // Footer Button
            _buildFooter(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.htmlTaskerBg,
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
            'Sensory-Safe Reader',
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
  
  Widget _buildContentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.htmlCardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.black.withOpacity(0.03),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          if (widget.result.title != null && widget.result.title!.isNotEmpty)
            Center(
              child: Text(
                widget.result.title!,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4A708B),
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 24),
          
          // Content
          Text(
            widget.result.simplifiedText,
            style: TextStyle(
              fontSize: 17.6,
              color: const Color(0xFF444444),
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.htmlTaskerBg,
      child: GestureDetector(
        onTap: _isLoading ? null : _handleDone,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF4A708B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLoading ? 'Finishing...' : 'DONE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
      ),
    );
  }
  
  Future<void> _handleDone() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
