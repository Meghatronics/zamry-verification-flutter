import 'package:flutter/services.dart';

class WeightInputFormatter extends TextInputFormatter {
  // Number of digits allowed before the decimal point
  final int maxDigitsBeforeDecimal;

  // Number of digits allowed after the decimal point
  final int decimalPlaces;

  WeightInputFormatter({
    this.maxDigitsBeforeDecimal = 6, // Default value
    this.decimalPlaces = 2, // Default value
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Check if there's more than one decimal point
    if (newText.replaceAll(RegExp(r'[^.]'), '').length > 1) {
      newText = oldValue.text; // Revert to old value
    }

    // Check if there's a leading zero
    if (newText.startsWith('0') && newText.length > 1) {
      newText = newText.substring(1);
    }

    // Check if the number of digits before the decimal point exceeds the limit
    if (newText.contains('.') &&
        newText.substring(0, newText.indexOf('.')).length >
            maxDigitsBeforeDecimal) {
      newText = oldValue.text; // Revert to old value
    }

    // Check if there's a decimal point
    if (newText.contains('.')) {
      // Check if the number of decimal places exceeds the limit
      if (newText.split('.')[1].length > decimalPlaces) {
        newText = oldValue.text; // Revert to old value
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
