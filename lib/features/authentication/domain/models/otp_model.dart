class OtpModel {
  final String id;
  final String receiverNumber;
  final String code;
  final OtpStatus status;
  final VerificationType type;

  OtpModel({
    required this.id,
    required this.receiverNumber,
    required this.code,
    required this.status,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      "otpCode": code,
      // "requester": "string",
      // "countryCode": "string",
      "agentNumber": receiverNumber,
      "status": status.serverCode,
      // "webhookUrl": "string",
      "otpType": type.serverCode,
    };
  }

  factory OtpModel.fromMap(Map<String, dynamic> map) {
    return OtpModel(
      id: map['id'].toString(),
      receiverNumber: map['agentNumber'] ?? '',
      code: map['otp'] ?? '',
      status: OtpStatus.values.firstWhere(
        (t) => t.serverCode == map['status'],
        orElse: () => OtpStatus.pending,
      ),
      type: VerificationType.values.firstWhere(
        (t) => t.serverCode == map['otpType'],
        orElse: () => VerificationType.sms,
      ),
    );
  }
}

enum OtpStatus {
  pending('PENDING'),
  expired('EXPIRED'),
  success('SUCCESS'),
  failed('FAILED');

  final String serverCode;
  const OtpStatus(this.serverCode);
}

enum VerificationType {
  sms('SMS'),
  droppedCall('DROPPED_CALL'),
  missedCall('RECEIVED_CALL');

  final String serverCode;
  const VerificationType(this.serverCode);
}
