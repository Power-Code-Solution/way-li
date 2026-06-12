import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wayli/app/core/config/auth_controller.dart';

class LoginController extends GetxController {
  static final GlobalKey loginBottomNavigationKey = GlobalKey();
  final AuthController authController = Get.find<AuthController>();
  final email = TextEditingController();
  final pass = TextEditingController();

  final loginViewFormKey = GlobalKey<FormState>();
  final visiblePassword = true.obs;
  final isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
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

  Future<void> handleLogin() async {
    if (loginViewFormKey.currentState?.validate() ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
      isLoading.value = true;
      final result = await authController.login(
        email.text.trim(),
        pass.text,
      );

      if (result) {
        authController.completePostLoginFlow();
        email.clear();
        pass.clear();
      }
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    visiblePassword.value = !visiblePassword.value;
    if (kDebugMode) {
      print("Password visibility toggled: ${visiblePassword.value}");
    }
  }
}
