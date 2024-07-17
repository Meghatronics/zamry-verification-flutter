import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/presentation/presentation.dart';
import '../services/app_lifecycle_service/app_lifecycle_service.dart';
import 'environment_config.dart';

class ThisApplication extends StatefulWidget {
  const ThisApplication({super.key});

  @override
  State<ThisApplication> createState() => _ThisApplicationState();
}

class _ThisApplicationState extends State<ThisApplication> {
  @override
  void initState() {
    AppLifecycleService.instance.initialise();
    super.initState();
  }

  @override
  void dispose() {
    AppLifecycleService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppViewBuilder<AppThemeManager>(
      model: AppThemeManager(
        lightTheme: AppTheme(
          colors: AppColors.defaultColors,
          headingFontFamily: AppStyles.defaultHeadingFont,
          bodyFontFamily: AppStyles.defaultBodyFont,
          child: const SizedBox.shrink(),
        ),
        darkTheme: null,
      ),
      builder: (themeManager, _) => MaterialApp(
        theme: themeManager.lightTheme,
        darkTheme: themeManager.darkTheme,
        themeMode: themeManager.themeMode,
        debugShowCheckedModeBanner: !EnvironmentConfig.isProd,
        title: EnvironmentConfig.appName,
        localizationsDelegates: const [],
        initialRoute: AppRoutes.splashRoute,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoutes,
        navigatorKey: AppNavigator.mainKey,
        navigatorObservers: [AppNavigatorObserver.instance],
        builder: (context, widget) {
          if (kReleaseMode) {
            const errT = Text('A rendering error occured');
            ErrorWidget.builder = (errorDetails) {
              if (widget is Scaffold || widget is Navigator) {
                return const Scaffold(body: Center(child: errT));
              } else {
                return errT;
              }
            };
          }
          return widget ?? const Scaffold();
        },
      ),
    );
  }
}
