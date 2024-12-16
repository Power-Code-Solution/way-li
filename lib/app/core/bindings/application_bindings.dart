import 'package:get/get.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/modules/login/login_controller.dart';

class ApplicationBindings extends Bindings {
  @override
  void dependencies() {
Get.put(AuthController());
Get.put(LoginController());
  }
}
