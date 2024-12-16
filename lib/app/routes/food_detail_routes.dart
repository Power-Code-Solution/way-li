import 'package:get/get.dart';

import '../modules/food_detail/food_detail_binding.dart';
import '../modules/food_detail/food_detail_view.dart';

class FoodDetailRoutes {
  FoodDetailRoutes._();

  static const foodDetail = '/food-detail';

  static final routes = [
    GetPage(
      name: foodDetail,
      page: () => FoodDetailView(FIL: {},),
      binding: FoodDetailBinding(),
    ),
  ];
}
