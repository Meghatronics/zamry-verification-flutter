import '../../features/shared/components/overlays/app_toast_widget.dart';
import '../../main/environment_config.dart';

mixin CustomWillPopScopeMixin {
  static bool _secondBack = false;
  static const secondTapDurationSpace = Duration(seconds: 2);
  Future<bool> onSecondBackPop() async {
    if (!_secondBack) {
      AppToast.info('Press back again to close ${EnvironmentConfig.appName}')
          .show();
      _secondBack = true;
      Future.delayed(secondTapDurationSpace, () => _secondBack = false);
      return false;
    } else {
      return true;
    }
  }

  Future<bool> delayAndPop() async {
    AppToast.info('Closing ${EnvironmentConfig.appName}').show();
    return Future.delayed(secondTapDurationSpace, () => true);
  }
}
