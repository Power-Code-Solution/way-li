import 'package:get/get.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';

class HomeRoutes {
  HomeRoutes._();

  static const home = '/home';

  static final routes = [
    GetPage(
      name: home,
      page: HomeView.new,
      binding: HomeBinding(),
    ),
  ];
}
