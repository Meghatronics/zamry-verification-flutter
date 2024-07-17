import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/presentation/presentation.dart';
import 'dashboard_vm.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar(
    this.dashVm, {
    this.height = 72,
    super.key,
  });
  final DashboardVm dashVm;
  final double height;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(top: 16, bottom: 4);
    final children = <Widget>[
      for (int i = 0; i < dashVm.data.length; i++)
        Expanded(
          child: InkResponse(
            onTap: () => dashVm.onTabSelected(i),
            radius: 40,
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  dashVm.data
                      .elementAt(i)
                      .activeIcon
                      .animate(target: i == dashVm.currentIndex ? 0 : 1)
                      .crossfade(
                        duration: 300.ms,
                        curve: Curves.easeOutCubic,
                        builder: (ctx) => dashVm.data.elementAt(i).inactiveIcon,
                      ),
                  const SizedBox(height: 4),
                  Text(
                    dashVm.data.elementAt(i).label,
                    textAlign: TextAlign.center,
                    style: AppStyles.of(context).caption12Regular.copyWith(
                          color: AppColors.of(context).grey900,
                        ),
                  ).animate(target: i == dashVm.currentIndex ? 1 : 0).tint(
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                        color: AppColors.of(context).primaryColor,
                      )
                ],
              ),
            ),
          ),
        ),
    ];

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.of(context).overlayBackground,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -9),
            color: const Color(0xFFB6B6B6).withOpacity(0.2),
            blurRadius: 29,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: children,
      ),
    );
  }
}
