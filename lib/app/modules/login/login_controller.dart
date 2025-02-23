import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/modules/tabs/tabs_view.dart';

import '../bottom_nav/bottom_nav_view.dart';


class LoginController extends GetxController {
  static final GlobalKey loginBottomNavigationKey = GlobalKey();
 final AuthController authController = Get.put(AuthController());
  var email = TextEditingController();
  var pass = TextEditingController();

  var loginViewFormKey = GlobalKey<FormState>();
  var visiblePassword = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    email.dispose();
    pass.dispose();
  }

  void handleLogin() async {
    if (loginViewFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      final result = await authController.login(email.text, pass.text);

      if (result) {

        Get.snackbar("Login Successful", "Welcome, ${authController.userName.value}",
            snackPosition: SnackPosition.BOTTOM);
             Get.offAll(() => BottomNavView);
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
    print("Password visibility toggled: ${visiblePassword.value}");
  }
}

