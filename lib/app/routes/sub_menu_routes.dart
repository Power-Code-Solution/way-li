import 'package:get/get.dart';

import '../modules/sub_menu/sub_menu_binding.dart';
import '../modules/sub_menu/sub_menu_view.dart';

class SubMenuRoutes {
  SubMenuRoutes._();

  static const subMenu = '/sub-menu';

  static final routes = [
    GetPage(
      name: subMenu,
      page: SubMenuView.new,
      binding: SubMenuBinding(),
    ),
  ];
}
