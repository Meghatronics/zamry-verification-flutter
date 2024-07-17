import 'package:flutter/material.dart';

import '../../../core/presentation/presentation.dart';
import '../../shared/components/input_fields/app_phone_number_field.dart';
import '../ui/dropped_call_verification_view.dart';
import '../ui/select_verification_view.dart';
import '../ui/sms_verification_view.dart';
import 'models/otp_model.dart';

class PhoneVerificationVm extends AppViewModel {
  static final countries = [
    PhoneCountryModel(name: 'Nigeria', iso2: 'NG', phoneCode: '234'),
    PhoneCountryModel(name: 'Ghana', iso2: 'GH', phoneCode: '233'),
  ];

  final phoneNumberField = PhoneInputController();
  final phoneForm = GlobalKey<FormState>();
  VerificationType? _verificationType;
  VerificationType? get verificationType => _verificationType;

  void init() {
    phoneNumberField.country.options = countries;
  }

  void selectVerificationType(VerificationType type) {
    _verificationType = type;
    setState();
  }

  void startVerification() {
    if (_verificationType == null) return;

    if (verificationType == VerificationType.sms) {
      return _startSmsVerification();
    }

    if (verificationType == VerificationType.droppedCall) {
      return _startDroppedCallVerification();
    }
  }

  void _startDroppedCallVerification() {
    AppNavigator.main.push(
      DroppedCallVerificationView(
        phone: phoneNumberField.phone.text.trim(),
        country: phoneNumberField.country.value!,
      ),
    );
  }

  void _startSmsVerification() {
    AppNavigator.main.push(
      SmsVerificationView(
        phone: phoneNumberField.phone.text.trim(),
        country: phoneNumberField.country.value!,
      ),
    );
  }

  void acceptNumber() {
    final valid = phoneForm.currentState?.validate() ?? false;
    if (!valid) return;

    AppNavigator.main.push(const SelectVerificationView());
  }
}
