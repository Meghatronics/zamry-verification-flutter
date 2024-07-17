import 'package:flutter/material.dart';

import '../../../../core/presentation/presentation.dart';
import '../../../../services/analytics_service/analytics_service.dart';
import '../loaders/app_loading_indicator.dart';

enum _ButtonType {
  primary,
  secondary,
  text;

  bool get isPrimary => this == primary;
  bool get isSecondary => this == secondary;
}

class AppButton extends StatelessWidget {
  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.color,
    this.textColor = Colors.white,
    this.enabled = true,
    this.view,
    this.wrap = false,
    this.icon,
  }) : _type = _ButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    // this.color,
    Color? outlineColor,
    this.enabled = true,
    this.view,
    this.wrap = false,
    this.icon,
  })  : _type = _ButtonType.secondary,
        color = null,
        textColor = outlineColor;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.textColor,
    this.enabled = true,
    this.view,
    this.wrap = false,
    this.icon,
  })  : _type = _ButtonType.text,
        color = Colors.transparent;

  final String label;
  final bool busy;
  final bool enabled;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final Object? view;
  final _ButtonType _type;
  final bool wrap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    //? Get label text color
    Color tColor;
    if (_type.isPrimary) {
      final textColor = this.textColor ?? colors.textAltColor;
      tColor = enabled ? textColor : colors.textAltColor;
    } else {
      final textColor = this.textColor ?? colors.primaryColor;
      tColor = enabled ? textColor : colors.grey600;
    }

    //? Get label text
    final textStyle = AppStyles.of(context).body16SemiBold.copyWith(
          color: tColor,
        );
    final labelText = FittedBox(
      child: Text(
        label,
        style: textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    //? Get full button child
    Widget child;
    if (busy) {
      child = const AppLoadingIndicator();
    } else if (icon == null) {
      child = labelText;
    } else {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [icon!, const SizedBox(width: 8), Flexible(child: labelText)],
      );
    }

    return TextButton(
      onPressed: enabled && !busy
          ? () {
              FocusScope.of(context).unfocus();
              onPressed();
              AnalyticsService.instance.logEvent(
                'Button Press',
                properties: {
                  'Name': label,
                  if (view != null) 'Location': view.toString(),
                  'Type': _type.name,
                },
              );
            }
          : null,
      style: ButtonStyle(
        splashFactory: InkSplash.splashFactory,
        minimumSize: MaterialStateProperty.all(
          wrap ? const Size(40, 48) : const Size.fromHeight(48),
        ),
        padding: MaterialStateProperty.all(
          busy
              ? const EdgeInsets.all(4)
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        backgroundColor: MaterialStateColor.resolveWith((states) {
          if (!_type.isPrimary) return Colors.transparent;
          if (states.contains(MaterialState.disabled)) {
            return colors.grey600;
          }
          if (states.contains(MaterialState.pressed) ||
              states.contains(MaterialState.focused)) {
            return colors.grey200;
          }
          if (states.contains(MaterialState.hovered)) {
            return colors.attitudeWarningLight;
          }
          return color ?? colors.primaryColor;
        }),
        shape: MaterialStateProperty.resolveWith((states) {
          if (_type == _ButtonType.text) return null;

          Color? getBorderColor(Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return tColor.withOpacity(0.8);
            }
            if (!_type.isSecondary) return null;
            if (states.contains(MaterialState.disabled)) {
              return colors.grey600;
            }
            // if (states.contains(MaterialState.pressed)) {
            //   return tColor;
            // }
            return tColor;
          }

          final color = getBorderColor(states);

          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(wrap ? 20 : 8),
            side: color != null
                ? BorderSide(
                    width: 1,
                    color: color,
                  )
                : BorderSide.none,
          );
        }),
      ),
      child: child,
    );
  }
}
