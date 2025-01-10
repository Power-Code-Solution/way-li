import 'package:get/get.dart';

import 'ingredents_controller.dart';

class IngredentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IngredentsController>(
      IngredentsController.new,
    );
  }
}
