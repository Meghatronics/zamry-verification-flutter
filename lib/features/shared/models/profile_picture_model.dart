class ProfilePictureModel {
  final bool error;
  final int statusCode;
  final String message;
  final ProfilePictureData data;

  ProfilePictureModel({
    required this.error,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ProfilePictureModel.fromMap(Map<String, dynamic> map) {
    return ProfilePictureModel(
      error: map['error'] ?? false,
      statusCode: map['statusCode'] ?? 0,
      message: map['message'] ?? '',
      data: ProfilePictureData.fromMap(map['data'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'error': error,
      'statusCode': statusCode,
      'message': message,
      'data': data.toMap(),
    };
  }
}

class ProfilePictureData {
  final String url;

  ProfilePictureData({required this.url});

  factory ProfilePictureData.fromMap(Map<String, dynamic> map) {
    return ProfilePictureData(
      url: map['url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
    };
  }
}
