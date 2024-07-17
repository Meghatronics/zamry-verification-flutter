import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../../core/presentation/presentation.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../utilities/mixins/device_clipboard_mixin.dart';
import '../../shared/components/buttons_and_ctas/app_button_widget.dart';
import '../../shared/components/input_fields/app_phone_number_field.dart';
import '../../shared/components/loaders/app_loading_indicator.dart';
import '../../shared/components/others/custom_app_bar.dart';
import '../domain/sms_verification_vm.dart';

class SmsVerificationView extends StatelessWidget with DeviceClipboardMixin {
  const SmsVerificationView({
    super.key,
    required this.phone,
    required this.country,
  });
  final String phone;
  final PhoneCountryModel country;

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final colors = context.colors;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Aprify'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: AppViewBuilder<SmsVerificationVm>(
          model: ServiceLocator.get(),
          initState: (vm) => vm.init(country, phone),
          builder: (vm, _) {
            if (vm.isBusy && vm.code.isEmpty) {
              return const EmptyStateWidget(
                mainText: 'Generating Otp',
                illustration: AppLoadingIndicator(),
              );
            }

            return Align(
              alignment: const Alignment(0, -0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE7FFF8),
                    ),
                    child: Icon(
                      IconsaxOutline.message_2,
                      color: colors.primaryColor,
                      size: 24,
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Instruction
                  Text(
                    'Send the text below as an SMS from ${vm.yourNumber}',
                    style: styles.body14Regular,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Send To: ',
                    style: styles.label14Regular,
                    textAlign: TextAlign.left,
                  ),

                  InkWell(
                    onTap: () => copyToClipboard(
                      vm.receiverNumber,
                      feedbackMessage: 'Recipient Number copied to clipboard',
                    ),
                    child: Container(
                      height: 56,
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.grey500, width: 0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        vm.receiverNumber,
                        style: styles.value16Medium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    'SMS',
                    style: styles.label14Regular,
                    textAlign: TextAlign.left,
                  ),

                  InkWell(
                    onTap: () => copyToClipboard(
                      vm.code,
                      feedbackMessage: 'SMS content copied to clipboard',
                    ),
                    child: Container(
                      height: 56,
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.grey500, width: 0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        vm.code,
                        style: styles.value16Medium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  AppButton.primary(
                    label: 'Tap to Send',
                    onPressed: vm.triggerSms,
                  ),
                  const SizedBox(height: 16),
                  AppButton.text(
                    label: 'I have sent the SMS',
                    onPressed: vm.goToLoadingView,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
