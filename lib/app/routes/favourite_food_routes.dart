import 'package:get/get.dart';

import '../modules/favourite_food/favourite_food_binding.dart';
import '../modules/favourite_food/favourite_food_view.dart';

class FavouriteFoodRoutes {
  FavouriteFoodRoutes._();

  static const favouriteFood = '/favourite-food';

  static final routes = [
    GetPage(
      name: favouriteFood,
      page: FavouriteFoodView.new,
      binding: FavouriteFoodBinding(),
    ),
  ];
}
