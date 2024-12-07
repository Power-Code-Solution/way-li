import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  //TODO: Implement RegistrationController.

 var name = TextEditingController();
 var email = TextEditingController();
 var phone = TextEditingController();
 var city = TextEditingController();
 var community = TextEditingController();
 var address = TextEditingController();
 var pass = TextEditingController();
  var confPass = TextEditingController();

  var registrationViewFormKey = GlobalKey<FormState>();
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
