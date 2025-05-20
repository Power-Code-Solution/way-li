import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:local_auth/local_auth.dart';

import 'bottom_nav_view.dart';

class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper>
    with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print('App resumed — attempting authentication');
      bool isAuthenticated = false;

      try {
        isAuthenticated = await auth.authenticate(
          localizedReason: 'Unlock WAY LI to continue',
          options: const AuthenticationOptions(
            biometricOnly: false,
            stickyAuth: true,
          ),
        );
      } catch (e) {
        print('Authentication error: $e');
      }

      if (!isAuthenticated) {
        Get.offAllNamed('/login');
        Get.snackbar('Security', 'Authentication required to continue');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavView(); // 👈 Your existing view
  }
}
