import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:wayli/app/modules/login/login_controller.dart';

import 'package:flutter/widgets.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  final Future<void> Function() onResumeCallback;
  final LoginController loginController = Get.put(LoginController());
  final LocalAuthentication auth = LocalAuthentication(); // ✅ Define this
  DateTime? _lastAuthTime; // ✅ Define this

  AppLifecycleHandler({required this.onResumeCallback});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print('App resumed');

      // ✅ Skip if recently authenticated (e.g. within 60 seconds)
      if (_lastAuthTime != null &&
          DateTime.now().difference(_lastAuthTime!) < Duration(seconds: 60)) {
        print('Skipping auth: recent login');
        return;
      }

      try {
        final isAuthenticated = await auth.authenticate(
          localizedReason: 'Unlock to continue',
          options: const AuthenticationOptions(
            biometricOnly: false,
            stickyAuth: true,
          ),
        );

        if (isAuthenticated) {
          _lastAuthTime = DateTime.now(); // ✅ Save timestamp
          print('Authentication success');
        } else {
          print('Authentication failed');
          Get.offAllNamed('/login');
        }
      } catch (e) {
        print('Authentication error: $e');
        Get.offAllNamed('/login');
      }
    }
  }
}
