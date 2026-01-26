import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../models/task_model.dart';

/// Task Deconstructor result screen (matches tasker.html exactly)
class TaskerResultScreen extends StatefulWidget {
  final TaskResult result;
  
  const TaskerResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<TaskerResultScreen> createState() => _TaskerResultScreenState();
}

class _TaskerResultScreenState extends State<TaskerResultScreen> {
  late List<bool> _checkedSteps;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _checkedSteps = widget.result.steps.map((s) => s.isCompleted).toList();
  }
  
  int get _completedCount => _checkedSteps.where((c) => c).length;
  int get _totalCount => _checkedSteps.length;
  int get _progressPercent => _totalCount > 0 
      ? ((_completedCount / _totalCount) * 100).round() 
      : 0;
  
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    // Progress Text
                    Text(
                      '$_progressPercent% Complete',
                      style: TextStyle(
                        fontSize: 14.4,
                        fontWeight: FontWeight.w600,
                        color: AppColors.htmlAccentGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Task Title
                    Text(
                      widget.result.originalTask,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF555555),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Steps List
                    Expanded(
                      child: ListView.separated(
                        itemCount: widget.result.steps.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final step = widget.result.steps[index];
                          return _buildStepCard(step, index);
                        },
                      ),
                    ),
                  ],
                ),
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
            'Your Steps',
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
  
  Widget _buildStepCard(TaskStep step, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.htmlCardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Circular Checkbox
          GestureDetector(
            onTap: () {
              setState(() {
                _checkedSteps[index] = !_checkedSteps[index];
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _checkedSteps[index] 
                    ? AppColors.htmlAccentGreen 
                    : Colors.white,
                border: Border.all(
                  color: _checkedSteps[index] 
                      ? AppColors.htmlAccentGreen 
                      : const Color(0xFFDDDDDD),
                  width: 2,
                ),
              ),
              child: _checkedSteps[index]
                  ? Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ),
          const SizedBox(width: 20),
          
          // Step Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.stepText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF444444),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: const Color(0xFF999999),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '10 minutes',
                      style: TextStyle(
                        fontSize: 12.8,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ],
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
            color: AppColors.htmlAccentGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLoading ? 'Finalizing...' : 'Done',
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
      ),
    );
  }
  
  Future<void> _handleDone() async {
    setState(() => _isLoading = true);
    
    // Navigate back to home
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
