import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/tabs/tabs_binding.dart';
import '../modules/tabs/tabs_view.dart';

class TabsRoutes {
  TabsRoutes._();
static final GlobalKey bottomNavigationKey = GlobalKey();
  static const tabs = '/tabs';

  static final routes = [
    GetPage(
      name: tabs,
      page: () => TabsView(bottomNavigationKey: bottomNavigationKey,),
      binding: TabsBinding(),
    ),
  ];
}

