import 'package:aprify/features/shared/components/input_fields/app_phone_number_field.dart';

import '../../../core/data/data.dart';
import '../../../services/rest_network_service/rest_network_service.dart';
import '../domain/models/otp_model.dart';

class AuthRepo extends AppRepository {
  final RestNetworkService _apiService;

  AuthRepo({required RestNetworkService apiService}) : _apiService = apiService;

  Future<DataResponse<OtpModel>> createSmsOtp({
    required String phone,
    required PhoneCountryModel country,
  }) =>
      _createOtp(
        phone: phone,
        country: country,
        type: VerificationType.sms,
      );

  Future<DataResponse<OtpModel>> createDroppedCallOtp({
    required String phone,
    required PhoneCountryModel country,
  }) =>
      _createOtp(
        phone: phone,
        country: country,
        type: VerificationType.droppedCall,
      );

  Future<DataResponse<OtpModel>> _createOtp({
    required String phone,
    required PhoneCountryModel country,
    required VerificationType type,
  }) =>
      runDataWithGuard(() async {
        final request = JsonRequest.post('/otp/request', {
          'phoneNumber': '${country.phoneCode}$phone',
          'countryCode': country.name.toLowerCase(),
          'type': type.serverCode,
        });

        final response = await _apiService.sendJsonRequest(request);
        final otpModel = OtpModel.fromMap(response['data']);
        return DataResponse(data: otpModel);
      });

  Future<DataResponse<OtpModel>> queryOtpStatus({required OtpModel otp}) =>
      runDataWithGuard(() async {
        final request = JsonRequest.get('/otp/${otp.id}');

        final response = await _apiService.sendJsonRequest(request);
        final otpModel = OtpModel.fromMap(response['data']);
        return DataResponse(data: otpModel);
      });
}
