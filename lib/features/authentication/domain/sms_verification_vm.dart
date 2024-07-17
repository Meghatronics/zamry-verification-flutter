import 'dart:async';

import '../../../core/presentation/presentation.dart';
import '../../../services/url_launcher_service/url_launcher_service.dart';
import '../../shared/components/buttons_and_ctas/app_button_widget.dart';
import '../../shared/components/input_fields/app_phone_number_field.dart';
import '../../shared/components/overlays/app_success_sheet.dart';
import '../../shared/components/overlays/app_toast_widget.dart';
import '../data/auth_repo.dart';
import '../ui/select_verification_view.dart';
import '../ui/waiting_view.dart';
import 'models/otp_model.dart';

class SmsVerificationVm extends AppViewModel {
  late PhoneCountryModel _country;
  late String _phone;
  OtpModel? _otp;

  final AuthRepo _repo;
  final UrlLauncherService _urlLauncherService;

  SmsVerificationVm({
    required AuthRepo repo,
    required UrlLauncherService urlLauncherService,
  })  : _repo = repo,
        _urlLauncherService = urlLauncherService;

  String get yourNumber => '${_country.phoneCode}$_phone';
  String get receiverNumber => _otp?.receiverNumber ?? '';
  String get code => _otp?.code ?? '';

  void init(PhoneCountryModel country, String phone) {
    _country = country;
    _phone = phone;
    _createSmsOtp();
  }

  Future<void> _createSmsOtp() async {
    setState(VmState.busy);
    final createOtp = await _repo.createSmsOtp(
      country: _country,
      phone: _phone,
    );
    if (createOtp.isSuccessful) {
      _otp = createOtp.data;
      setState(VmState.none);
      _startQuery();
    } else {
      handleErrorAndSetVmState(createOtp.error!);
      AppNavigator.main.pop();
    }
  }

  Future<void> _startQuery() async {
    if (_otp == null) return;

    OtpModel otp = _otp!;

    // final timer = Timer(const Duration(seconds: 90), () {});
    while (otp.status == OtpStatus.pending) {
      final fetchOtp = await _repo.queryOtpStatus(otp: otp);

      if (fetchOtp.isSuccessful) {
        otp = fetchOtp.data!;
        _otp = otp;
        if (otp.status != OtpStatus.pending) break;
      }
      // if (!timer.isActive) break;
      await Future.delayed(const Duration(seconds: 5));
    }

    if (otp.status == OtpStatus.success) {
      callback() {
        AppNavigator.main.pushNamedAndClear(AppRoutes.dashboardRoute);
      }

      AppSuccessSheet(
        title: 'Phone number verified',
        message: 'Your phone $yourNumber has been verified successfully',
        dismissCallBack: callback,
        buttons: [
          AppButton.primary(
            label: 'Go to dashaboard',
            onPressed: callback,
          )
        ],
      ).show();
    } else if (hasListeners) {
      AppNavigator.main.popUntilType(SelectVerificationView);
      AppToast.error('Otp ${otp.status.name}. Please try again').show();
    }
  }

  void goToLoadingView() {
    AppNavigator.main.push(const WaitingView());
  }

  void triggerSms() {
    _urlLauncherService.sendSms(receiverNumber, body: code);
  }

  
}
