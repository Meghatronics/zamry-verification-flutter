import 'package:flutter/widgets.dart';

class AppResources {
  AppResources._();
  static final i = AppResources._();

  static const imagesDir = 'assets/images';
  static const iconsDir = 'assets/icons';
  static const lottieDir = 'assets/animations';

//! Icons

  final avatarDefault = '';

//! Images
  final appLogo = const AssetImage('$imagesDir/app_logo.png');
  //! Svgs

  //! Others

//! Lotties
  final logoLottie = '$lottieDir/animated_logo_lottie.json';
  final notFoundAnimation = '$lottieDir/default_animation.json';
  final attentionAnimation = '$lottieDir/default_animation.json';
}
