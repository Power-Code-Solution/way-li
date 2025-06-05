import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  //TODO: Implement OtpController.

  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> otpKey;

  @override
  void onInit() {
    super.onInit();
    otpKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
  }

  void disposeResources() {
    pinController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void validatePin() {
    if (otpKey.currentState!.validate()) {
      print('Pin is valid: ${pinController.text}');
    } else {
      print('Pin is invalid');
    }
  }
}
