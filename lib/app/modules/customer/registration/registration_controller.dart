import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:wayli/app/core/model/users.dart';
import 'package:wayli/app/modules/login/login_view.dart';
import 'package:wayli/app/modules/otp/otp_view.dart';
import 'package:wayli/app/modules/tabs/tabs_view.dart';

class RegistrationController extends GetxController {
  //TODO: Implement RegistrationController.

  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var confPassword = TextEditingController();
  var phone = TextEditingController();
  var address = TextEditingController();
  var fkCityIdController = TextEditingController();
  var fkCommunityIdController = TextEditingController();

  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> otpKey;



  var isLoading = false.obs;

  var registrationViewFormKey = GlobalKey<FormState>();
  bool visiblePassword = true;
  bool isClientConnected = false;
  bool isOuvrierConnected = false;
  get sharePre => null;

  @override
  void onInit() {
    super.onInit();
        otpKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    confPassword.dispose();
    phone.dispose();
    address.dispose();
    fkCityIdController.dispose();
    fkCommunityIdController.dispose();
    super.onClose();
  }

  Future<void> createUser() async {
    try {
      if (password.text != confPassword.text) {
        Get.snackbar(
          "Error",
          "Passwords do not match! Please check your password",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;
      final user = CreateUsers(
        firstName: firstName.text,
        lastName: lastName.text,
        email: email.text,
        password: password.text,
        phone: phone.text,
        address: address.text,
        fkCityId: int.tryParse(fkCityIdController.text) ?? 0,
        fkCommunityId: int.tryParse(fkCommunityIdController.text) ?? 0,
      );

      final response = await http.post(
        Uri.parse("$apiBaseAddress/secure/admin/user/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "User added successfully.",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(() => LoginView());
        clearFields();
      } else {
        print({response.body});
        Get.snackbar(
          "Error",
          "Failed to add user: ${response.body}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    firstName.clear();
    lastName.clear();
    email.clear();
    password.clear();
    phone.clear();
    address.clear();
    fkCityIdController.clear();
    fkCommunityIdController.clear();
  }
}
