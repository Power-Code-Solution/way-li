import 'package:get/get.dart';

import 'sub_menu_food_controller.dart';

class SubMenuFoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubMenuFoodController>(
      SubMenuFoodController.new,
    );
  }
}
