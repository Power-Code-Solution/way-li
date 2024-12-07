import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController.

  var email = TextEditingController();
  var pass = TextEditingController();

  var loginViewFormKey = GlobalKey<FormState>();
  bool visiblePassword = true;
  bool isClientConnected = false;
  bool isOuvrierConnected = false;
get sharePre => null;

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
  }
}
