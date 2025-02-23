import 'package:get/get.dart';

import 'bottom_nav_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(
      BottomNavController.new,
    );
  }
}
