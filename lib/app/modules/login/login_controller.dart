import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayli/app/core/config/auth_controller.dart';

import '../../core/config/constants.dart';
import '../bottom_nav/bottom_nav_view.dart';

class LoginController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();

  static final GlobalKey loginBottomNavigationKey = GlobalKey();
  final AuthController authController = Get.put(AuthController());
  RxBool showFingerprint = false.obs;
  var email = TextEditingController();
  var pass = TextEditingController();

  var loginViewFormKey = GlobalKey<FormState>();
  var visiblePassword = true.obs;
  var isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await checkFingerprintStatus();

    if (showFingerprint.value) {
      authenticate();
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    email.dispose();
    pass.dispose();
  }

  Future<void> enableFingerprintLogin() async {
    final localAuth = LocalAuthentication();

    try {
      bool isDeviceSupported = await localAuth.isDeviceSupported();
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (!isDeviceSupported || !canCheckBiometrics) {
        Get.snackbar(
            'Not Supported', 'This device does not support biometrics.');
        return;
      }

      bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Confirm your identity to enable fingerprint login',
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow device password, PIN, etc.
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_fingerprint_enabled', true);
        showFingerprint.value = true; // Update the state if using Obx
        Get.snackbar('Success', 'Fingerprint login enabled!');
      } else {
        Get.snackbar('Cancelled', 'Authentication failed or was cancelled.');
      }
    } catch (e) {
      print('Auth error: $e');
      Get.snackbar('Error', 'An error occurred while enabling fingerprint.');
    }
  }

  Future<void> authenticate() async {
    try {
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        Get.offAll(() => BottomNavView());
        Get.snackbar('Success', 'Authenticated!');
      } else {
        Get.snackbar('Failed', 'Authentication failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error using biometric auth: $e');
      print('Error using biometric auth: $e');
    }
  }

  Future<void> checkFingerprintStatus() async {
    final prefs = await SharedPreferences.getInstance();
    showFingerprint.value = prefs.getBool('is_fingerprint_enabled') ?? false;
  }

  void handleLogin() async {
    if (loginViewFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      final result = await authController.login(email.text, pass.text);

      if (result) {
        isLoading.value = false;

        // Ask if user wants to enable fingerprint
        bool enable = await Get.dialog(
          AlertDialog(
            title: AutoSizeText(
              "Enable Fingerprint?",
              style: GoogleFonts.montserrat(),
            ),
            content: AutoSizeText(
              "Would you like to enable fingerprint login for next time?",
              style: GoogleFonts.montserrat(),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AutoSizeText(
                    "No",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AutoSizeText(
                    "Yes",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

        if (enable == true) {
          if (enable == true) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('is_fingerprint_enabled', true);
            showFingerprint.value = true;
          }
        }
        Get.offAll(() => BottomNavView());
        email.clear();
        pass.clear();
      } else {
        Get.snackbar("Login Failed", "Invalid email or password.",
            snackPosition: SnackPosition.BOTTOM);
      }

      isLoading.value = false;
    } else {
      Get.snackbar("Validation Error", "Please fill in all fields correctly.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void togglePasswordVisibility() {
    visiblePassword.value = !visiblePassword.value;
    if (kDebugMode) {
      print("Password visibility toggled: ${visiblePassword.value}");
    }
  }
}
