import 'dart:async';

import 'package:flutter/material.dart';

import '../core/presentation/theming/app_theme_manager.dart';
import '../core/service_locator/service_locator.dart';
import '../services/error_logging_service/error_logging_service.dart';
import 'application.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // await Firebase.initializeApp(options: EnvironmentConfig.firebaseOptions);
      await ServiceLocator.registerDependencies();
      await AppThemeManager.initialise();
      runApp(const ThisApplication());
    },
    (error, stack) {
      ErrorLogService.instance.recordError(error, stack, fatal: true);
    },
  );
}
