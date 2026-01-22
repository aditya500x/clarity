import 'package:flutter/material.dart';

class PanicViewModel extends ChangeNotifier {
  // Logic for panic mode state (e.g., breath count) can move here
  // For animation controllers, it's often easier to keep them in the State<T> or use a specialized provider
  // For this simple example, we can keep the animation logic in the View, or try to abstract it.
  // Sticking to MVVM, the ViewModel should expose the "State" (text, count), but the AnimationController is a View concern.

  String getBreathingText(int breathCount, int totalBreaths, bool isInhaling) {
    if (breathCount >= totalBreaths) {
      return "You're doing great! 💙";
    }

    if (isInhaling) {
      return 'Breathe in slowly...';
    } else {
      return 'Breathe out gently...';
    }
  }
}
