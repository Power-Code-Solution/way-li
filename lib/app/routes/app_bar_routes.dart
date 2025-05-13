import 'package:get/get.dart';

import '../modules/app_bar/app_bar_binding.dart';
import '../modules/app_bar/app_bar_page.dart';

sealed class AppBarRoutes {
  static const appBar = '/app-bar';

  static final routes = [
    GetPage(
      name: appBar,
      page: () => const AppBarPage(),
      binding: AppBarBinding(),
    ),
  ];
}
