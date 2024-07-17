import 'package:flutter/services.dart';

class BloodPressureInputFormatter extends TextInputFormatter {
  // Number of digits allowed before and after the slash
  final int maxDigits;

  BloodPressureInputFormatter({this.maxDigits = 3});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove non-digit and non-slash characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9/]'), '');

    // Insert slash after max digits before the slash
    final addSlash = newText.length >= maxDigits &&
        !newText.contains('/') &&
        newValue.text.length > oldValue.text.length;
    if (addSlash) {
      newText =
          '${newText.substring(0, maxDigits)}/${newText.substring(maxDigits)}';
    }

    // Check if there's more than one slash
    if (newText.replaceAll(RegExp(r'[^/]'), '').length > 1) {
      newText = oldValue.text; // Revert to old value
    }

    // Limit the number of digits before and after the slash
    List<String> parts = newText.split('/');
    if (parts.length == 2) {
      if (parts[0].length > maxDigits) {
        parts[0] = parts[0].substring(0, maxDigits);
      }
      if (parts[1].length > maxDigits) {
        parts[1] = parts[1].substring(0, maxDigits);
      }
      newText = '${parts[0]}/${parts[1]}';
    }
    bool noChanges = newText.length == oldValue.text.length;
    bool inBetween = newValue.selection.extentOffset <= newText.length;
    return TextEditingValue(
      text: newText,
      selection: noChanges && !inBetween
          ? oldValue.selection
          : TextSelection.collapsed(
              offset: newValue.selection.extentOffset + (addSlash ? 1 : 0),
            ),
    );
  }
}
