import 'package:get/get.dart';

import 'tabs_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabsController>(
      TabsController.new,
    );
  }
}
