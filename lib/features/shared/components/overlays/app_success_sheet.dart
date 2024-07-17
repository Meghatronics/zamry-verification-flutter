import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/presentation.dart';
import '../buttons_and_ctas/app_button_widget.dart';
import 'app_bottom_sheet.dart';

class AppSuccessSheet extends AppBottomSheet<void> {
  AppSuccessSheet({
    super.key,
    required String? title,
    required String? message,
    required VoidCallback dismissCallBack,
    required List<AppButton> buttons,
  }) : super(
          heading: null,
          dismissCallback: dismissCallBack,
          isDismissable: true,
          builder: (context) {
            final styles = AppStyles.of(context);
            final colors = AppColors.of(context);
            final size = MediaQuery.sizeOf(context).width * 0.35;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: size,
                  child: Icon(
                    IconsaxOutline.verify,
                    color: colors.attitudeSuccessMain,
                    size: size,
                  ),
                ),
                const SizedBox(height: 24),
                if (title != null)
                  Text(
                    title,
                    style: styles.heading20Semibold
                        .copyWith(color: colors.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),
                if (message != null)
                  Text(
                    message,
                    style: title == null
                        ? styles.body16Medium
                        : styles.body14Regular,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 24),
                ...buttons,
                const SizedBox(height: kToolbarHeight),
              ],
            );
          },
        );
}
