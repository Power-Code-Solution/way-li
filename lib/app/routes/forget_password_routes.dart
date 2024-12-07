import 'package:get/get.dart';

import '../modules/forget_password/forget_password_binding.dart';
import '../modules/forget_password/forget_password_view.dart';

class ForgetPasswordRoutes {
  ForgetPasswordRoutes._();

  static const forgetPassword = '/forget-password';

  static final routes = [
    GetPage(
      name: forgetPassword,
      page: ForgetPasswordView.new,
      binding: ForgetPasswordBinding(),
    ),
  ];
}
