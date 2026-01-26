import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/tab_input_widget.dart';
import '../../services/api_service.dart';
import '../../utils/helpers.dart';
import 'tasker_result_screen.dart';

/// Task Deconstructor input screen (Module 1)
class TaskerScreen extends StatefulWidget {
  const TaskerScreen({super.key});
  
  @override
  State<TaskerScreen> createState() => _TaskerScreenState();
}

class _TaskerScreenState extends State<TaskerScreen> {
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
  
  Future<void> _submitTask(String inputData, String inputMethod) async {
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
      final result = await _apiService.sendTask(
        _sessionId!,
        inputData,
        inputMethod,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Break down complex tasks into simple steps',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              
              Expanded(
                child: TabInputWidget(
                  onSubmit: _submitTask,
                  textHint: 'e.g., Plan a birthday party',
                  textLabel: 'Enter your task',
                  maxLines: 4,
                ),
              ),
            ],
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
