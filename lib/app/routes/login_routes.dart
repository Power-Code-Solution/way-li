import 'package:get/get.dart';

import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';

class LoginRoutes {
  LoginRoutes._();

  static const login = '/login';

  static final routes = [
    GetPage(
      name: login,
      page: LoginView.new,
      binding: LoginBinding(),
    ),
  ];
}
