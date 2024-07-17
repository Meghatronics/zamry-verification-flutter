import 'package:flutter/material.dart';

import '../../../../core/presentation/presentation.dart';
import '../buttons_and_ctas/app_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.child,
  });
  final String title;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final showBackButton = AppNavigator.of(context).canPop;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, kToolbarHeight, 16, 16),
      color: context.colors.backgroundColor,
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 48,
            height: 40,
            margin: const EdgeInsets.only(right: 8.0),
            alignment: Alignment.centerLeft,
            child: showBackButton ? const AppBackButton() : const SizedBox(),
          ),
          Expanded(
            child: Text(
              title,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppStyles.of(context).body16SemiBold,
            ),
          ),
          Container(
            width: 48,
            margin: const EdgeInsets.only(left: 8),
            alignment: Alignment.centerRight,
            child: child,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 24);
}
