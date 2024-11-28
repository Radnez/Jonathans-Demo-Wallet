import 'package:flutter/services.dart';

TextInputFormatter expiryDateFormatter() {
  return TextInputFormatter.withFunction((oldValue, newValue) {
    String newText = newValue.text;

    // Handle leading zero for months 2-9
    if (newText.length == 1 &&
        int.tryParse(newText) != null &&
        int.parse(newText) >= 2) {
      newText = '0$newText';
    }

    // Automatically insert slash after two digits (month part)
    if (newText.length == 2 && !newText.contains('/')) {
      newText = '$newText/';
    }

    // Handle backspace properly (allow deletion of slash)
    if (oldValue.text.length > newValue.text.length) {
      if (oldValue.text.endsWith('/') && newValue.text.length == 2) {
        newText = newText.substring(0, 1); // Remove the slash when backspacing
      }
    }

    // Ensure the month stays valid (01-12)
    if (newText.length >= 2 && newText.contains('/')) {
      String month = newText.substring(0, 2);
      if (int.tryParse(month) != null && int.parse(month) > 12) {
        newText = '12${newText.substring(2)}'; // Correct invalid month to '12'
      }
    }

    // Limit the input length to 5 (MM/YY)
    if (newText.length > 5) {
      newText = newText.substring(0, 5);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  });
}
