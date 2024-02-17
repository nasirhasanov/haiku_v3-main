import 'package:flutter/services.dart';

class MaxLinesTextInputFormatter extends TextInputFormatter {
  final int maxLines;

  MaxLinesTextInputFormatter({required this.maxLines});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final lines = newValue.text.split('\n');
    if (lines.length > maxLines) {
      return oldValue;
    }
    return newValue;
  }
}