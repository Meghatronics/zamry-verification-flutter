enum UrlLaunchMethod {
  inApp,
  externalBrowser,
}

abstract class UrlLauncherService {
  Future<bool> openWebUrl(
    Uri uri, {
    UrlLaunchMethod method = UrlLaunchMethod.inApp,
  });

  Future<bool> openLink(Uri uri);

  Future<bool> sendEmail(
    String emailAddress, {
    required String subject,
    required String body,
  });

  Future<bool> sendSms(String phone, {required String body});
}
