import 'package:intl/intl.dart';

/// Helper utility functions
class Helpers {
  /// Format timestamp for chat messages
  static String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return DateFormat('HH:mm').format(timestamp);
    } else {
      return DateFormat('MMM dd, HH:mm').format(timestamp);
    }
  }
  
  /// Format error message for user display
  static String formatErrorMessage(dynamic error) {
    final errorString = error.toString();
    
    if (errorString.contains('SocketException') || errorString.contains('Failed host lookup')) {
      return 'Cannot connect to server. Please check your internet connection.';
    } else if (errorString.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    } else if (errorString.contains('FormatException')) {
      return 'Received invalid response from server.';
    } else {
      return 'An error occurred. Please try again.';
    }
  }
  
  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
