import 'package:flutter/material.dart';

import '../../../core/presentation/presentation.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../shared/components/buttons_and_ctas/app_button_widget.dart';
import '../../shared/components/input_fields/app_phone_number_field.dart';
import '../../shared/components/others/custom_app_bar.dart';
import '../domain/phone_verification_vm.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final colors = context.colors;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Aprify'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: const Alignment(0, -0.5),
          child: AppViewBuilder<PhoneVerificationVm>(
            model: ServiceLocator.get(),
            initState: (vm) => vm.init(),
            builder: (vm, _) => Form(
              key: vm.phoneForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Verify your phone number',
                    style: styles.heading20Semibold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We want to verify your phone number',
                    style: styles.body14Regular,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  AppPhoneNumberField(
                    controller: vm.phoneNumberField,
                    validator: (number, country) {
                      if (number == null || number.isEmpty) {
                        return 'Phone number is required';
                      }
                      if (country == null) return 'Select your country code';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppButton.primary(
                    label: 'Proceed',
                    onPressed: vm.acceptNumber,
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      text: 'By signing up, you agree to our\n',
                      style: styles.body14Regular,
                      children: [
                        TextSpan(
                          text: 'Privacy policy and Terms of Service',
                          style: styles.body14Medium
                              .copyWith(color: colors.primaryColor),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
