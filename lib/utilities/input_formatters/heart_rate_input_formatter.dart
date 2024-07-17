import 'package:flutter/services.dart';

class HeartRateInputFormatter extends TextInputFormatter {
  // Number of digits allowed
  final int maxDigits;

  HeartRateInputFormatter({this.maxDigits = 3});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit the number of digits
    if (newText.length > maxDigits) {
      newText = newText.substring(0, maxDigits);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
