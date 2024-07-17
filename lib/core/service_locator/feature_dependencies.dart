import 'dart:async';

import 'package:aprify/features/dashboard/dashboard_vm.dart';

import '../../features/authentication/data/auth_repo.dart';
import '../../features/authentication/domain/dropped_call_verification_vm.dart';
import '../../features/authentication/domain/phone_verification_vm.dart';
import '../../features/authentication/domain/sms_verification_vm.dart';
import 'service_locator.dart';

class FeatureDependencies extends ServiceLocator {
  FeatureDependencies(super.locator);

  @override
  FutureOr<void> register() {
    locator.registerLazySingleton(() => PhoneVerificationVm());
    locator.registerFactory(() => AuthRepo(apiService: locator()));

    locator.registerFactory(() => SmsVerificationVm(
          repo: locator(),
          urlLauncherService: locator(),
        ));

    locator.registerFactory(() => DroppedCallVerificationVm(
          repo: locator(),
          urlLauncherService: locator(),
        ));

    locator.registerLazySingleton(() => DashboardVm());
  }
}
