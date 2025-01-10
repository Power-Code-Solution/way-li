import 'package:get/get.dart';

import '../modules/sub_menu_food/sub_menu_food_binding.dart';
import '../modules/sub_menu_food/sub_menu_food_view.dart';

class SubMenuFoodRoutes {
  SubMenuFoodRoutes._();

  static const subMenuFood = '/sub-menu-food';

  static final routes = [
    GetPage(
      name: subMenuFood,
      page: SubMenuFoodView.new,
      binding: SubMenuFoodBinding(),
    ),
  ];
}
