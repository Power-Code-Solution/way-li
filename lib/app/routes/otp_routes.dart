import 'package:get/get.dart';

import '../modules/otp/otp_binding.dart';
import '../modules/otp/otp_view.dart';

class OtpRoutes {
  OtpRoutes._();

  static const otp = '/otp';

  static final routes = [
    GetPage(
      name: otp,
      page: OtpView.new,
      binding: OtpBinding(),
    ),
  ];
}
