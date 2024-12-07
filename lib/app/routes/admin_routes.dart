import 'package:get/get.dart';
import '../modules/admin/admin_users/admin_users_binding.dart';
import '../modules/admin/admin_users/admin_users_view.dart';

class AdminRoutes {
  AdminRoutes._();

  static const users = '/admin/users';
	static const adminUsers = '/admin/admin-users';

  static final routes = [
    GetPage(
      name: users,
      page: AdminUsersView.new,
      binding: AdminUsersBinding(),
    ),
		GetPage(
      name: adminUsers,
      page: AdminUsersView.new,
      binding: AdminUsersBinding(),
    ),
  ];
}
