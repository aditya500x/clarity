class TaskStep {
  final String title;
  final String timeEstimate;
  bool isCompleted;

  TaskStep({
    required this.title,
    required this.timeEstimate,
    this.isCompleted = false,
  });
}
