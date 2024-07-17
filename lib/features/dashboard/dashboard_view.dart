import 'package:flutter/material.dart';

import '../../core/presentation/app_view_builder.dart';
import '../../core/service_locator/service_locator.dart';
import 'app_bottom_nav_bar_widget.dart';
import 'dashboard_vm.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardVm = ServiceLocator.get<DashboardVm>();
    return WillPopScope(
      onWillPop: dashboardVm.onWillPop,
      child: AppViewBuilder<DashboardVm>(
        model: dashboardVm,
        initState: (dashboardVm) => dashboardVm.setup(),
        builder: (dashboardVm, _) => Scaffold(
          body: IndexedStack(
            index: dashboardVm.currentIndex,
            children: [
              for (final data in dashboardVm.data) data.page,
            ],
          ),
          bottomNavigationBar: AppBottomNavBar(dashboardVm),
        ),
      ),
    );
  }
}
