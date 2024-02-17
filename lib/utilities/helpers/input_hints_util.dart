import 'dart:math';

class HintsUtil {
  static final List<String> _addPostHints = [
    'Along this road, \nGoes no one.\nThis autumn eve.',
    'A frog jumps into the pond,\nSplash!\nSilence again...',
    'Express yourself...',
    'Tell us your story...',
  ];

  static String getRandomPostHint() {
    final randomIndex = Random().nextInt(_addPostHints.length);
    return _addPostHints[randomIndex];
  }
}