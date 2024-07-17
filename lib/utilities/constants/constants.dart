abstract class Constants {
  const Constants._();

  static const networkTimeoutDuration = Duration(seconds: 30);
  static const toastAnimationDuration = Duration(milliseconds: 400);
  static const toastDefaultDuration = Duration(seconds: 4);
  static const splashAnimationDuration = Duration(seconds: 2);
  static const currencySymbol = '₦';
  static const phoneNumberRegExp = r'^[1-9]\d{9,14}$';
  static const List<String> bloodGroups = [
    'O+',
    'A+',
    'B+',
    'AB+',
    'O-',
    'A-',
    'B-',
    'AB-'
  ];

  static const List<String> genotypes = ['AA', 'AS', 'AC', 'SS', 'SC', 'CC'];

  static const List<String> countries = [
    'Nigeria',
  ];

  static const List<String> states = [
    'Lagos',
  ];
}
