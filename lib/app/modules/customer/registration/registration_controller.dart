import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:wayli/app/core/model/users.dart';
import 'package:wayli/app/core/model/device_model.dart';
import 'package:wayli/app/modules/login/login_view.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RegistrationController extends GetxController {
  //TODO: Implement RegistrationController.

  var fullname = TextEditingController();
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

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void onInit() {
    super.onInit();
    otpKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
  }

  Future<DeviceInfo> getDeviceInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      return DeviceInfo(
        name: androidInfo.model,
        identifier: androidInfo.id,
        version: androidInfo.version.release,
        appVersion: appVersion,
        system: 'Android',
        os: androidInfo.version.sdkInt.toString(),
        verified: false,
        biometric: false,
      );
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
      return DeviceInfo(
        name: iosInfo.name ?? iosInfo.model!,
        identifier: iosInfo.identifierForVendor!,
        version: iosInfo.systemVersion!,
        appVersion: appVersion,
        system: 'iOS',
        os: iosInfo.systemName!,
        verified: false,
        biometric: false,
      );
    } else {
      return DeviceInfo(
        name: 'Unknown',
        identifier: 'Unknown',
        version: 'Unknown',
        appVersion: appVersion,
        system: 'Unknown',
        os: 'Unknown',
        verified: false,
        biometric: false,
      );
    }
  }

  @override
  void onClose() {
    fullname.dispose();
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

      // Get device information
      DeviceInfo deviceInfo = await getDeviceInfo();

      final user = CreateUsers(
        fullname: fullname.text,
        email: email.text,
        password: password.text,
        phone: phone.text,
        address: address.text,
        fkCityId: int.tryParse(fkCityIdController.text) ?? 0,
        fkCommunityId: int.tryParse(fkCommunityIdController.text) ?? 0,
        device: deviceInfo,
      );

      final url = Uri.parse("$apiBaseAddress/secure/admin/user/create");
      final body = jsonEncode(user.toJson());
      print('[DEBUG_LOG] POST ' + url.toString());
      print('[DEBUG_LOG] Headers: {Content-Type: application/json}');
      print('[DEBUG_LOG] Payload: ' + body);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
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
    fullname.clear();
    email.clear();
    password.clear();
    phone.clear();
    address.clear();
    fkCityIdController.clear();
    fkCommunityIdController.clear();
  }
}
