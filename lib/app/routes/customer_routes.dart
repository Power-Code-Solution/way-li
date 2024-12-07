import 'package:get/get.dart';

import '../modules/customer/registration/registration_binding.dart';
import '../modules/customer/registration/registration_view.dart';
import '../modules/customer/customer_profile/customer_profile_binding.dart';
import '../modules/customer/customer_profile/customer_profile_view.dart';
import '../modules/customer/order_history/order_history_binding.dart';
import '../modules/customer/order_history/order_history_view.dart';

class CustomerRoutes {
  CustomerRoutes._();

  static const registration = '/customer/registration';
	static const customerProfile = '/customer/customer-profile';
	static const orderHistory = '/customer/order-history';

  static final routes = [
    GetPage(
      name: registration,
      page: RegistrationView.new,
      binding: RegistrationBinding(),
    ),
		GetPage(
      name: customerProfile,
      page: CustomerProfileView.new,
      binding: CustomerProfileBinding(),
    ),
		GetPage(
      name: orderHistory,
      page: OrderHistoryView.new,
      binding: OrderHistoryBinding(),
    ),
  ];
}
