import 'package:get/get.dart';

import 'food_category_controller.dart';

class FoodCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodCategoryController>(
      FoodCategoryController.new,
    );
  }
}
