import 'package:flutter/services.dart';

class AutoCapitalizeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty || newValue.text == oldValue.text) {
      return newValue;
    }

    final text = newValue.text;
    final buffer = StringBuffer();

    bool capitalizeNext = true;
    for (int i = 0; i < text.length; i++) {
      final char = text[i];

      if (capitalizeNext && char.isNotEmpty) {
        buffer.write(char.toUpperCase());
        capitalizeNext = false;
      } else {
        buffer.write(char);
      }

      // Check for punctuation to determine if the next character should be capitalized
      if (char == '.' || char == '!' || char == '?') {
        capitalizeNext = true;
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: newValue.selection,
    );
  }
}
