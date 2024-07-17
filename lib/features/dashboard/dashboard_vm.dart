import 'dart:collection';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/mixins/custom_will_pop_scope_mixin.dart';
import '../../core/presentation/presentation.dart';

class DashboardVm extends AppViewModel with CustomWillPopScopeMixin {
  DashboardVm();

  int _currentIndex = 0;
  get _data => <DashboardPageData>[
    DashboardPageData(
      label: 'Home',
      page: Container(
        constraints: const BoxConstraints.expand(),
        alignment: Alignment.center,
        child: EmptyStateWidget(
          mainText: 'Welcome to your dashboard',
          illustration: Icon(
            IconsaxBold.message,
            color: AppColors.defaultColors.primaryColor,
          ),
        ),
      ),
      activeIcon: const Icon(IconsaxBold.home),
      inactiveIcon: const Icon(IconsaxOutline.home),
    ),
    const DashboardPageData(
      label: 'Crypto',
      page: Placeholder(),
      activeIcon: Icon(IconsaxBold.graph),
      inactiveIcon: Icon(IconsaxOutline.graph),
    ),
    const DashboardPageData(
      label: 'Transactions',
      page: Placeholder(),
      activeIcon: Icon(IconsaxBold.wallet),
      inactiveIcon: Icon(IconsaxOutline.wallet),
    ),
    const DashboardPageData(
      label: 'Profile',
      page: Placeholder(),
      activeIcon: Icon(IconsaxBold.user),
      inactiveIcon: Icon(IconsaxOutline.user),
    ),
  ];

  int get currentIndex => _currentIndex;
  DashboardPageData get currentPage => data.elementAt(_currentIndex);
  Type get currentPageType => data[currentIndex].runtimeType;
  UnmodifiableListView<DashboardPageData> get data =>
      UnmodifiableListView(_data);

  void setup() {}

  void onTabSelected(int index) {
    _currentIndex = index;
    setState();
  }

  Future<bool> onWillPop() {
    if (currentIndex != 0) {
      onTabSelected(0);
      return Future.value(false);
    } else {
      return onSecondBackPop();
    }
  }
}

class DashboardPageData {
  final Widget activeIcon;
  final Widget inactiveIcon;
  final Widget page;
  final String label;

  const DashboardPageData({
    required this.label,
    required this.page,
    required this.activeIcon,
    required this.inactiveIcon,
  });

  DashboardPageData.image({
    required this.label,
    required this.page,
    required ImageProvider activeIconData,
    required ImageProvider inactiveIconData,
  })  : activeIcon = Image(
          image: activeIconData,
          color: AppColors.of(AppNavigator.main.currentContext).primaryColor,
          height: 14, width: 14,
          // colorBlendMode: BlendMode.darken,
        ),
        inactiveIcon = Image(
          image: inactiveIconData,
          color: AppColors.of(AppNavigator.main.currentContext).grey900,
          height: 14, width: 14,
          // colorBlendMode: BlendMode.darken,
        );

  static const size = 64.0;
}
