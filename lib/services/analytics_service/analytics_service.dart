import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/service_locator/service_locator.dart';
import '../../features/shared/models/user_model.dart';
import '../app_lifecycle_service/app_lifecycle_service.dart';

abstract class AnalyticsService {
  static final AnalyticsService instance =
      ServiceLocator.get<AnalyticsService>();

  NavigatorObserver get navigatorObserver;

  bool _shouldRecord = false;

  bool get isRecording => _shouldRecord;

  @mustCallSuper
  FutureOr<void> configure([bool shouldRecord = true]) {
    _shouldRecord = shouldRecord && kReleaseMode;
    AppLifecycleService.instance.addListener((appIsPaused) {
      if (appIsPaused) flushLogUpload();
    });
  }

  FutureOr<void> logInUser(UserModel user);
  FutureOr<void> logOutUser();

  FutureOr<void> logEvent(
    String name, {
    Map<String, dynamic>? properties,
  });

  Future<void> flushLogUpload();
}

class DummyAnalytics extends AnalyticsService {
  @override
  Future<void> flushLogUpload() async {}

  @override
  FutureOr<void> logEvent(String name, {Map<String, dynamic>? properties}) {}

  @override
  FutureOr<void> logInUser(UserModel user) {}

  @override
  FutureOr<void> logOutUser() {}

  @override
  NavigatorObserver get navigatorObserver => NavigatorObserver();
}
