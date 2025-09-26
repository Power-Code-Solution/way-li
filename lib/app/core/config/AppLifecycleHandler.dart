import 'package:flutter/widgets.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  final Future<void> Function() onResumeCallback;

  AppLifecycleHandler({required this.onResumeCallback});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // Call the provided callback on resume, without enforcing biometric auth
      await onResumeCallback();
    }
  }
}
