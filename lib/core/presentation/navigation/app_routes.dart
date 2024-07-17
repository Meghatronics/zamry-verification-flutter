import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../features/authentication/ui/start_view.dart';
import '../../../features/dashboard/dashboard_view.dart';
import '../presentation.dart';

abstract class AppRoutes {
  static const dashboardRoute = 'DashboardView';
  static const loginRoute = 'LoginView';
  static const splashRoute = 'welcome';

  static Route<T> generateRoutes<T>(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return getPageRoute(settings: settings, view: const StartView());
      case dashboardRoute:
        return getPageRoute(settings: settings, view: const DashboardView());
      default:
        return getPageRoute<T>(
          settings: settings,
          view: Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
                style: TextStyle(
                  color: AppColors.defaultColors.textColor,
                ),
              ),
            ),
          ),
        );
    }
  }

  static final routes = <String, WidgetBuilder>{
    //
  };

  static Route<T> getPageRoute<T>({
    required RouteSettings settings,
    required Widget view,
  }) {
    if (settings.name == null) {
      settings = RouteSettings(
        name: view.runtimeType.toString(),
        arguments: settings.arguments,
      );
    }

    return Platform.isIOS
        ? CupertinoPageRoute<T>(settings: settings, builder: (_) => view)
        : MaterialPageRoute<T>(settings: settings, builder: (_) => view);
  }
}
