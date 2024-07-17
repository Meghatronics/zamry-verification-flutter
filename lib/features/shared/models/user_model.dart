class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool allowPN;
  final String referralCode;
  final String? avatarUrl;
  final Gender gender;
  final DateTime? dob;
  final int age;
  final String? phone;
  final String? genotype;
  final String? bloodGroup;
  final String userAccessToken;

  final bool hasActiveSubscription;

  final String? address;
  final String? city;
  final String? state;
  final String? country;

  final int profileCompletionRate;
  final bool isProfileCompleted;

  String get fullName => '$firstName $lastName';

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    required this.allowPN,
    required this.referralCode,
    required this.gender,
    required this.dob,
    required this.age,
    required this.phone,
    required this.bloodGroup,
    required this.genotype,
    required this.hasActiveSubscription,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.profileCompletionRate,
    required this.isProfileCompleted,
    required this.userAccessToken,
  });

  UserModel.fromFirebase({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    // required this.refe,
  })  : gender = Gender.male,
        phone = null,
        genotype = null,
        bloodGroup = null,
        referralCode = '',
        allowPN = true,
        dob = DateTime.now(),
        age = 0,
        address = '',
        city = '',
        state = '',
        country = '',
        userAccessToken = '',
        profileCompletionRate = 0,
        isProfileCompleted = false,
        hasActiveSubscription = false;

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    Gender? gender,
    DateTime? dob,
    bool? allowPN,
    String? referralCode,
    String? phone,
    String? genotype,
    String? bloodGroup,
    int? age,
    String? address,
    String? city,
    String? state,
    String? country,
    int? profileCompletionRate,
    bool? isProfileCompleted,
    bool? hasActiveSubscription,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      allowPN: allowPN ?? this.allowPN,
      referralCode: referralCode ?? this.referralCode,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      genotype: genotype ?? this.genotype,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      address: address,
      city: city,
      state: state,
      country: country,
      profileCompletionRate:
          profileCompletionRate ?? this.profileCompletionRate,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      hasActiveSubscription:
          hasActiveSubscription ?? this.hasActiveSubscription,
      userAccessToken: userAccessToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'allowPushNotification': allowPN,
      'personalReferralCode': referralCode,
      'avatarUrl': avatarUrl,
      'sex': gender.name,
      'dateOfBirth': dob?.toIso8601String(),
      'age': age,
      'phoneNumber': phone,
      'genotype': genotype,
      'bloodGroup': bloodGroup,
      'subscriptionStatus': {'active': hasActiveSubscription},
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'profileCompletionRate': profileCompletionRate,
      'isProfileCompleted': isProfileCompleted,
      'userAccessToken': userAccessToken,
      // 'avatar': 'string',
      // 'settings': {'inviteExpiryTime': 0},
      // 'nin': 'string',
      // 'occupation': 'string',
      // 'maritalStatus': 'string',
      // 'bvn': 'string',
      // 'referredByCode': 'string',
      // 'signature': 'string'
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      allowPN: map['allowPushNotification'],
      referralCode: map['personalReferralCode'] ?? '',
      avatarUrl: map['avatarUrl'],
      gender: Gender.values.firstWhere(
        (v) => v.name == map['sex'],
        orElse: () => Gender.female,
      ),
      dob: DateTime.tryParse(map['dateOfBirth'] ?? ''),
      age: int.tryParse(map['age'].toString()) ?? 0,
      phone: (map['phoneNumber'] as String? ?? '').replaceAll('+', ''),
      genotype: map['genotype'],
      bloodGroup: map['bloodGroup'],
      hasActiveSubscription: (map['subscriptionStatus'] ?? {})['active'],
      address: map['address'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      profileCompletionRate: map['profileCompleted']['completionRate'] ?? 0,
      isProfileCompleted: map['profileCompleted']['isCompleted'] ?? false,
      userAccessToken: map['userAccessToken'] ?? '',
    );
  }
}

enum Gender {
  male('Male'),
  female('Female');

  final String name;
  const Gender(this.name);
}
