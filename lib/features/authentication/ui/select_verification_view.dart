import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/presentation/presentation.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../shared/components/buttons_and_ctas/app_button_widget.dart';
import '../../shared/components/others/custom_app_bar.dart';
import '../domain/models/otp_model.dart';
import '../domain/phone_verification_vm.dart';
import 'widgets/method_tile.dart';

class SelectVerificationView extends StatelessWidget {
  const SelectVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppViewBuilder<PhoneVerificationVm>(
      model: ServiceLocator.get(),
      builder: (vm, _) => Scaffold(
        appBar: const CustomAppBar(title: 'Aprify'),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
            children: [
              if (vm.verificationType != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: AppButton.primary(
                    label: 'Start Verification',
                    onPressed: vm.startVerification,
                  ).animate().fadeIn(),
                ),
              /*  MethodTile(
                icon: IconsaxOutline.call_incoming,
                title: 'Missed Call',
                description: 'We will call you on this line [Fastest]',
                onTap: () =>
                    vm.selectVerificationType(VerificationType.missedCall),
                highlight: vm.verificationType == VerificationType.missedCall,
              ),
              const SizedBox(height: 16), */
              MethodTile(
                icon: IconsaxOutline.message_2,
                title: 'SMS',
                description: 'Send us an SMS. Recommended '
                    'if you have free or cheap sms',
                onTap: () => vm.selectVerificationType(VerificationType.sms),
                highlight: vm.verificationType == VerificationType.sms,
              ),
              const SizedBox(height: 16),
              MethodTile(
                icon: IconsaxOutline.call_outgoing,
                title: 'Call Us',
                description: 'You can send us a dropped/missed call to to verify yourself',
                onTap: () =>
                    vm.selectVerificationType(VerificationType.droppedCall),
                highlight: vm.verificationType == VerificationType.droppedCall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
