import 'package:get/get.dart';

import 'allergens_controller.dart';

class AllergensBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllergensController>(
      AllergensController.new,
    );
  }
}
