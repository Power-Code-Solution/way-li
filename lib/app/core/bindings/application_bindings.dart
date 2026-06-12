import 'package:get/get.dart';
import 'package:wayli/app/core/config/auth_controller.dart';

class ApplicationBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
  }
}
