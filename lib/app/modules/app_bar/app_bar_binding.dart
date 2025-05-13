import 'package:get/get.dart';

import 'app_bar_controller.dart';

class AppBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppBarController>(
      () => AppBarController(),
    );
  }
}
