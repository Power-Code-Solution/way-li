import 'package:get/get.dart';

import '../modules/splash_screen/splash_screen_binding.dart';
import '../modules/splash_screen/splash_screen_view.dart';

class SplashScreenRoutes {
  SplashScreenRoutes._();

  static const splashScreen = '/splash-screen';

  static final routes = [
    GetPage(
      name: splashScreen,
      page: SplashScreenView.new,
      binding: SplashScreenBinding(),
    ),
  ];
}
