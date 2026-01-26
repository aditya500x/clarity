import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/loading_indicator.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';
import '../../config/constants.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';
import 'tasker_result_screen.dart';

/// Task Deconstructor input screen (Module 1)
class TaskerScreen extends StatefulWidget {
  const TaskerScreen({super.key});
  
  @override
  State<TaskerScreen> createState() => _TaskerScreenState();
}

class _TaskerScreenState extends State<TaskerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();
  final _apiService = ApiService();
  final _sessionService = SessionService();
  bool _isLoading = false;
  
  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
  
  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final sessionId = await _sessionService.getSessionId();
      final result = await _apiService.sendTask(
        sessionId,
        _taskController.text.trim(),
        AppConstants.inputMethodParagraph,
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskerResultScreen(result: result),
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
      title: 'Task Deconstructor',
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Break down complex tasks into simple steps',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                
                TextFormField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your task',
                    hintText: 'e.g., Plan a birthday party',
                  ),
                  maxLines: 4,
                  validator: Validators.validateTask,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitTask,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Break Down Task'),
                ),
              ],
            ),
          ),
          
          // Loading overlay
          if (_isLoading)
            const LoadingIndicator(
              isOverlay: true,
              message: 'Breaking down your task...',
            ),
        ],
      ),
    );
  }
}
