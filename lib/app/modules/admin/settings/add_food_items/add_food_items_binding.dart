import 'package:get/get.dart';

import 'add_food_items_controller.dart';

class AddFoodItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFoodItemsController>(
      AddFoodItemsController.new,
    );
  }
}
