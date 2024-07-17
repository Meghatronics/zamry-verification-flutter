import 'package:flutter/material.dart';

import '../../../../core/presentation/presentation.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key, this.controller, required this.tabs});
  final TabController? controller;
  final List<AppTab> tabs;
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.grey300,
        borderRadius: BorderRadius.circular(64),
      ),
      child: TabBar(
        tabAlignment: TabAlignment.fill,
        indicatorPadding: const EdgeInsets.all(4),
        tabs: tabs,
      ),
    );
  }
}

class AppTab extends Tab {
  const AppTab({
    super.key,
    super.text,
    super.icon,
    super.iconMargin = const EdgeInsets.only(right: 4),
  });
  static const double _kTabHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    final double calculatedHeight;
    final Widget label;
    if (icon == null) {
      calculatedHeight = _kTabHeight;
      label = _buildLabelText();
    } else if (text == null && child == null) {
      calculatedHeight = _kTabHeight;
      label = icon!;
    } else {
      calculatedHeight = _kTabHeight;
      label = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: iconMargin,
            child: icon,
          ),
          _buildLabelText(),
        ],
      );
    }

    return SizedBox(
      height: height ?? calculatedHeight,
      child: Center(
        widthFactor: 1.5,
        child: label,
      ),
    );
  }

  Widget _buildLabelText() {
    return Text(text!, softWrap: false, overflow: TextOverflow.fade);
  }
}
