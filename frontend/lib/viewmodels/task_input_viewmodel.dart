import 'package:flutter/material.dart';

class TaskInputViewModel extends ChangeNotifier {
  final TextEditingController taskController = TextEditingController();

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  bool validateInput() {
    return taskController.text.trim().isNotEmpty;
  }

  String get taskText => taskController.text;
}
