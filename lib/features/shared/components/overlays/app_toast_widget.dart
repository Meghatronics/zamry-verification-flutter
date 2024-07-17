import 'package:flutter/material.dart';

import '../../../../core/presentation/presentation.dart';
import '../../../../utilities/constants/constants.dart';

class AppToast {
  final String message;
  final bool userCanDismiss;
  final Duration duration;
  final Alignment alignment;
  final AppToastType type;

  @protected
  late AnimationController animationController;
  OverlayEntry? _overlayEntry;

  AppToast.error(
    this.message, {
    Key? key,
    this.userCanDismiss = false,
    this.alignment = Alignment.topCenter,
    this.duration = Constants.toastDefaultDuration,
    BuildContext? context,
  }) : type = AppToastType.error;

  AppToast.success(
    this.message, {
    Key? key,
    this.userCanDismiss = true,
    this.alignment = Alignment.topCenter,
    this.duration = Constants.toastDefaultDuration,
    BuildContext? context,
  }) : type = AppToastType.success;

  AppToast.info(
    this.message, {
    Key? key,
    this.userCanDismiss = true,
    this.alignment = Alignment.topCenter,
    this.duration = Constants.toastDefaultDuration,
    BuildContext? context,
  }) : type = AppToastType.information;

  /// Shows the toast message on the screen.
  ///
  /// If the toast is already shown, nothing happens.
  /// Otherwise, it creates the toast widget using the given parameters and displays it in the
  /// nearest `Navigator`'s `Overlay`.
  /// It then removes the widget after the specified [duration] has passed.
  void show([BuildContext? context, Key? key]) {
    if (_overlayEntry?.mounted ?? false) return;
    final toastWidget = AppToastWidget(this, key: key);
    _overlayEntry = OverlayEntry(builder: (_) => toastWidget);
    Navigator.of(context ?? AppNavigator.main.currentContext)
        .overlay!
        .insert(_overlayEntry!);
    Future.delayed(duration).then((_) => remove());
  }

  /// Removes the toast message from the screen.
  ///
  /// If the toast is not showing, nothing happens
  /// Otherwise, it uses the animation controller to reverse the animation
  /// and then removes the overlay entry.
  void remove() {
    if (_overlayEntry?.mounted ?? false) {
      animationController.reverse().then((_) {
        _overlayEntry!.remove();
      });
    }
  }

  void dispose() {
    animationController.dispose();
  }
}

class AppToastWidget extends StatefulWidget {
  final AppToast toast;

  /// A widget that displays a toast notification.
  ///
  /// Args:
  ///     toast (AppToast): The toast to display.
  const AppToastWidget(
    this.toast, {
    super.key,
  });

  @override
  AppToastWidgetState createState() => AppToastWidgetState();
}

class AppToastWidgetState extends State<AppToastWidget>
    with SingleTickerProviderStateMixin {
  late AppToast _toast;
  @override
  void initState() {
    super.initState();
    _toast = widget.toast;
    _toast.animationController = AnimationController(
      vsync: this,
      duration: Constants.toastAnimationDuration,
    );
    _toast.animationController.forward();
  }

  @override
  void dispose() {
    _toast.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;

    // final rectOfPosition = _toast.alignment.inscribe(
    //   Size(screenSize.width - 32, 56),
    //   Rect.fromLTRB(
    //     24,
    //     kToolbarHeight + 24,
    //     screenSize.width - 24,
    //     screenSize.height - (kToolbarHeight + 24),
    //   ),
    // );

    return Positioned(
      // rect: rectOfPosition,
      left: 16, right: 16,
      top: _toast.alignment.y.isNegative ? kToolbarHeight + 24 : null,
      bottom: !_toast.alignment.y.isNegative ? kToolbarHeight + 24 : null,
      child: FadeTransition(
        opacity:
            _toast.animationController.drive(CurveTween(curve: Curves.easeOut)),
        child: ScaleTransition(
          scale: _toast.animationController
              .drive(CurveTween(curve: Curves.fastLinearToSlowEaseIn)),
          child: Material(
            type: MaterialType.transparency,
            child: GestureDetector(
              onTap: _toast.userCanDismiss ? _toast.remove : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _toast.type.bgColor,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  _toast.message,
                  style: AppStyles.of(context).body16Medium.copyWith(
                        color: _toast.type.textColor,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum AppToastType {
  success(Color(0xFF0A7214), Colors.white),
  error(Color(0xFF990A0A), Colors.white),
  information(Color(0xFF606060), Colors.white);

  const AppToastType(this.bgColor, this.textColor);
  final Color bgColor;
  final Color textColor;
}

/* import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/presentation/presentation.dart';

class AlertData {
  final String message;
  final Color borderColor;
  final Color mainColor;
  final String iconName;
  final VoidCallback? action;
  final String? actionLabel;

  AlertData(
    this.message, {
    required this.borderColor,
    required this.mainColor,
    required this.iconName,
    this.action,
    this.actionLabel,
  });
}

class AppToast {
  final String message;

  AppToast.errorToast(this.message) {
    showErrorToast(message);
  }

  AppToast.successToast(this.message) {
    showSuccessToast(message);
  }

  AppToast.warnToast(this.message) {
    showWarningToast(message);
  }

  Timer? _timerHolder;

  final BuildContext _context = AppNavigator.mainKey.currentContext!;
  final List<AlertData> _toastQueue = [];

  int get queueLength => _toastQueue.length;

  void _nextToastOnQueue() {
    if (_toastQueue.isNotEmpty) _toastBase(_toastQueue.first);
  }

  void _addToQueue(AlertData data) {
    if (_toastQueue.isEmpty || data.message != _toastQueue.last.message) {
      _toastQueue.add(data);
    }

    if (_timerHolder == null) {
      _nextToastOnQueue();
    }
  }

  void _removeToast() {
    _timerHolder?.cancel();
    _timerHolder = null;
    AppNavigator.of(_context).pop(_context);
    _toastQueue.removeAt(0);
  }

  void _toastBase(AlertData data) {
    var totalSeconds = 4;

    _timerHolder = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        _timerHolder = timer;
        totalSeconds = totalSeconds - 1;
        if (totalSeconds == 0) {
          _removeToast();
        }
      },
    );

    showGeneralDialog(
      routeSettings: const RouteSettings(name: 'Alert Toast'),
      context: AppNavigator.mainKey.currentContext!,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(
        AppNavigator.mainKey.currentState!.overlay!.context,
      ).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return WillPopScope(
          onWillPop: () {
            _removeToast();
            return Future.value(false);
          },
          child: GestureDetector(
            onTap: _removeToast,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2.5,
                  sigmaY: 2.5,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      25, kToolbarHeight + 48.0, 25, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: data.mainColor,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 8.0,
                            color: data.borderColor,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 16.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // SizedBox(
                                    //   height: 30.0,
                                    //   width: 30.0,
                                    //   child: AppUtil.svgPicture(data.iconName),
                                    // ),
                                    // const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Text(
                                        data.message,
                                        style: AppStyles.of(_context)
                                            .body16Bold
                                            .copyWith(
                                              color:
                                                  AppColors.of(_context).grey5,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //!
                            // if (data.action != null && data.actionLabel != null)
                            //   InkResponse(
                            //     onTap: data.action,
                            //     child: Container(
                            //       alignment: Alignment.center,
                            //       margin: const EdgeInsets.only(left: 8),
                            //       padding: const EdgeInsets.symmetric(
                            //         horizontal: 12,
                            //         vertical: 6,
                            //       ),
                            //       decoration: BoxDecoration(
                            //         color: data.color,
                            //       ),
                            //       child: Text(
                            //         '${data.actionLabel}',
                            //         style: const TextStyle(
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 14,
                            //           color: Color(0xFF010F25),
                            //         ),
                            //       ),
                            //     ),
                            //   )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) => _nextToastOnQueue());
  }

  void showErrorToast(
    String message, {
    VoidCallback? action,
    String? actionLabel,
  }) {
    _addToQueue(
      AlertData(
        message.isEmpty ? 'Something went wrong, try again.' : message,
        action: action,
        actionLabel: actionLabel,
        iconName: 'failed_toast_icon',
        borderColor: AppColors.of(_context).attitudeErrorMain,
        mainColor: AppColors.of(_context).attitudeErrorLight,
      ),
    );
  }

  void showSuccessToast(
    String message, {
    VoidCallback? action,
    String? actionLabel,
  }) {
    _addToQueue(
      AlertData(
        message,
        borderColor: AppColors.of(_context).attitudeSuccessMain,
        mainColor: AppColors.of(_context).attitudeSuccessLight,
        action: action,
        actionLabel: actionLabel,
        iconName: 'success_toast_icon',
      ),
    );
  }

  void showWarningToast(
    String message, {
    VoidCallback? action,
    String? actionLabel,
  }) {
    _addToQueue(
      AlertData(
        message,
        action: action,
        actionLabel: actionLabel,
        iconName: 'warning_toast_icon',
        borderColor: AppColors.of(_context).attitudeWarningMain,
        mainColor: AppColors.of(_context).attitudeWarningLight,
      ),
    );
  }
}
 */