import 'package:aprify/main/environment_config.dart';

import '../../core/service_locator/service_locator.dart';
import '../../features/shared/models/user_model.dart';
import '../../services/analytics_service/analytics_service.dart';
import '../../services/error_logging_service/error_logging_service.dart';
import 'app_view_model.dart';
import 'failure.dart';

typedef AuthModel = ({String token, UserModel user});

class SessionManager extends AppViewModel {
  // final LocalStorageService localStorageService;
  final ErrorLogService errorLogService;
  final AnalyticsService analyticsService;

  late String _token;
  late UserModel _currentUser;

  bool _sessionIsOpen = false;

  final Map _sessionHeaders = <String, String>{};

  SessionManager({
    // required this.localStorageService,
    required this.errorLogService,
    required this.analyticsService,
  });

  bool get isOpen => _sessionIsOpen;
  String? get accessToken => _sessionIsOpen ? _token : null;
  UserModel get currentUser => _currentUser;

  Map<String, String> sessionHeaders(bool withToken) {
    final Map<String, String> headers = Map.from(_sessionHeaders);
    if (!withToken) {
      return headers;
    } else {
      return headers
        ..putIfAbsent(
          'Authorization',
          () => 'Bearer ${EnvironmentConfig.apiKey}',
        )
        ..putIfAbsent('accept', () => 'application/json');
    }
  }

  void open({
    required AuthModel auth,
  }) {
    _token = auth.token;
    _sessionIsOpen = true;

    _currentUser = auth.user;
    errorLogService.connectUser(_currentUser);
    analyticsService.logInUser(_currentUser);

    setState();
  }

  Future<void> close() async {
    if (_sessionIsOpen) {
      // localStorageService.clearEntireStorage();
      errorLogService.disconnectUser();
      clearSessionHeaders();
      ServiceLocator.resetInstance<SessionManager>();
    }
  }

  bool updateUser(UserModel user) {
    if (_sessionIsOpen) {
      _currentUser = user;
      setState();
      errorLogService.connectUser(_currentUser);
      analyticsService.logInUser(_currentUser);
      return true;
    } else {
      return false;
    }
  }

  bool updateToken(String token) {
    if (_sessionIsOpen) {
      _token = token;
      return true;
    } else {
      return false;
    }
  }

  void setSessionHeaders(Map<String, String> x) {
    _sessionHeaders.addAll(x);
  }

  void clearSessionHeaders() {
    _sessionHeaders.clear();
  }

  bool isProfileDoesNotExistError(Failure? failure) {
    return failure is InputFailure &&
        failure.message.toUpperCase() ==
            'User Profile not created'.toUpperCase();
  }
}
