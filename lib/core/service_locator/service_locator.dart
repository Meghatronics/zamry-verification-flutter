import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../core/domain/session_manager.dart';
import '../../main/environment_config.dart';
import '../../services/analytics_service/analytics_service.dart';
import '../../services/error_logging_service/error_logging_service.dart';
import '../../services/rest_network_service/dio_network_service.dart';
import '../../services/rest_network_service/rest_network_service.dart';
import '../../services/url_launcher_service/url_launcher_impl_service.dart';
import '../../services/url_launcher_service/url_launcher_service.dart';
import '../../utilities/constants/constants.dart';
import 'feature_dependencies.dart';

abstract class ServiceLocator {
  final GetIt locator;
  ServiceLocator(this.locator);

  FutureOr<void> register();

  static final get = GetIt.instance;
  static Future<void> registerDependencies() async {
    final services = _ServiceDependencies(get);
    final features = FeatureDependencies(get);

    services.register();
    features.register();
  }

  static Future<void> reset() async {
    await get.reset();
    await registerDependencies();
  }

  static void resetInstance<T extends Object>() {
    get.resetLazySingleton<T>();
  }
}

class _ServiceDependencies extends ServiceLocator {
  _ServiceDependencies(super.locator);

  @override
  FutureOr<void> register() {
    locator.registerLazySingleton(() => SessionManager(
          // localStorageService: locator(),
          errorLogService: locator(),
          analyticsService: locator(),
        ));

    locator.registerLazySingleton<RestNetworkService>(() => DioNetworkService(
          sessionManager: locator(),
          baseUrl: EnvironmentConfig.apiUrl,
          sendTimeout: Constants.networkTimeoutDuration,
          isProd: EnvironmentConfig.isProd,
        ));

    locator.registerLazySingleton<ErrorLogService>(() {
      final service = ErrorLogService.instance;
      service.initialise(shouldLog: EnvironmentConfig.isProd);
      return service;
    });

    locator.registerLazySingleton<AnalyticsService>(
      () {
        final service = DummyAnalytics();
        service.configure(EnvironmentConfig.isProd);
        return service;
      },
    );

    locator.registerFactory<UrlLauncherService>(() => UrlLauncherImplService());
  }
}
