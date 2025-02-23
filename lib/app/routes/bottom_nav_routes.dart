import 'package:get/get.dart';

import '../modules/bottom_nav/bottom_nav_binding.dart';
import '../modules/bottom_nav/bottom_nav_view.dart';

class BottomNavRoutes {
  BottomNavRoutes._();

  static const bottomNav = '/bottom-nav';

  static final routes = [
    GetPage(
      name: bottomNav,
      page: BottomNavView.new,
      binding: BottomNavBinding(),
    ),
  ];
}
