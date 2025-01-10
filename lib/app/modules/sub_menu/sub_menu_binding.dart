import 'package:get/get.dart';

import 'sub_menu_controller.dart';

class SubMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubMenuController>(
      SubMenuController.new,
    );
  }
}
