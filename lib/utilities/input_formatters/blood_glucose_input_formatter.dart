import 'package:flutter/services.dart';

class BloodGlucoseInputFormatter extends TextInputFormatter {
  // Number of digits allowed before and after the decimal point
  final int maxDigitsBeforeDecimal;
  final int decimalPlaces;

  BloodGlucoseInputFormatter({
    this.maxDigitsBeforeDecimal = 3, // Default value
    this.decimalPlaces = 1, // Default value
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove non-digit and non-decimal characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Check if there's more than one decimal point
    if (newText.replaceAll(RegExp(r'[^.]'), '').length > 1) {
      newText = oldValue.text; // Revert to old value
    }

    // Limit the number of digits before the decimal point
    if (newText.contains('.') &&
        newText.substring(0, newText.indexOf('.')).length >
            maxDigitsBeforeDecimal) {
      newText = oldValue.text; // Revert to old value
    }

    // Limit decimal places
    if (newText.contains('.')) {
      List<String> splitText = newText.split('.');
      if (splitText.length > 1 && splitText[1].length > decimalPlaces) {
        newText = '${splitText[0]}.${splitText[1].substring(0, decimalPlaces)}'; // Limit decimal places
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
