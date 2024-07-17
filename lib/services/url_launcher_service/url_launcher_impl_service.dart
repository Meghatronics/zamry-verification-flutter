import 'package:url_launcher/url_launcher.dart';

import 'url_launcher_service.dart';

class UrlLauncherImplService implements UrlLauncherService {
  @override
  Future<bool> openWebUrl(
    Uri uri, {
    UrlLaunchMethod method = UrlLaunchMethod.inApp,
  }) async {
    if (!await canLaunchUrl(uri)) return false;
    final launchMode = method.toLaunchMode();
    return launchUrl(uri, mode: launchMode);
  }

  @override
  Future<bool> openLink(Uri uri) async {
    if (!await canLaunchUrl(uri)) return false;
    const launchMode = LaunchMode.externalApplication;
    return launchUrl(uri, mode: launchMode);
  }

  @override
  Future<bool> sendEmail(String emailAddress,
      {required String subject, required String body}) {
    final query = _encodeQueryParameters({
      'subject': subject,
      'body': body,
    });
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: query,
    );

    return launchUrl(emailLaunchUri);
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Future<bool> sendSms(String phone, {required String body}) {
    final smsLaunchUri = Uri(
      scheme: 'sms',
      path: phone,
      query: _encodeQueryParameters(
        {'body': body},
      ),
    );

    return openLink(smsLaunchUri);
  }
}

extension UrlLaunchMethodExtension on UrlLaunchMethod {
  LaunchMode toLaunchMode() {
    if (this == UrlLaunchMethod.inApp) {
      return LaunchMode.inAppWebView;
    } else if (this == UrlLaunchMethod.externalBrowser) {
      return LaunchMode.externalApplication;
    } else {
      return LaunchMode.platformDefault;
    }
  }
}
