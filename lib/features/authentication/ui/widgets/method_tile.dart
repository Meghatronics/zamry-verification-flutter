import 'package:flutter/material.dart';

import '../../../../core/presentation/presentation.dart';

class MethodTile extends StatelessWidget {
  const MethodTile({
    super.key,
    required IconData icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.highlight = false,
    this.tag,
  }) : _icon = icon;

  final IconData? _icon;
  final String title, description;
  final Widget? tag;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final styles = AppStyles.of(context);
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        // margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: highlight ? Border.all(color: colors.primaryColor) : null,
          color: colors.overlayBackground,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCBD8E0).withOpacity(0.5),
              blurRadius: 60,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE7FFF8),
              ),
              child: _icon != null
                  ? Icon(
                      _icon,
                      color: colors.primaryColor,
                      size: 24,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: styles.heading20Bold.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  if (tag != null)
                    tag!
                  else
                    Text(
                      description,
                      style: styles.body14Medium.copyWith(
                        color: colors.textColor,
                      ),
                    ),
                ],
              ),
            ),
            // const SizedBox(width: 16),
            // Icon(
            //   Icons.chevron_right,
            //   color: colors.primaryColor,
            //   size: 24,
            // ),
          ],
        ),
      ),
    );
  }
}
