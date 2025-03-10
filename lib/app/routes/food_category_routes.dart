import 'package:get/get.dart';

import '../modules/food_category/food_category_binding.dart';
import '../modules/food_category/food_category_view.dart';

class FoodCategoryRoutes {
  FoodCategoryRoutes._();

  static const foodCategory = '/food-category';

  static final routes = [
    GetPage(
      name: foodCategory,
      page: FoodCategoryView.new,
      binding: FoodCategoryBinding(),
    ),
  ];
}
