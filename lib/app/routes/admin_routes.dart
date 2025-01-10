import 'package:get/get.dart';
import '../modules/admin/admin_users/admin_users_binding.dart';
import '../modules/admin/admin_users/admin_users_view.dart';
import '../modules/admin/settings/menu/menu_binding.dart';
import '../modules/admin/settings/menu/menu_view.dart';
import '../modules/admin/settings/menu_category/menu_category_binding.dart';
import '../modules/admin/settings/menu_category/menu_category_view.dart';
import '../modules/admin/settings/settings_binding.dart';
import '../modules/admin/settings/settings_view.dart';
import '../modules/admin/settings/users/users_binding.dart';
import '../modules/admin/settings/users/users_view.dart';
import '../modules/admin/settings/tags/tags_binding.dart';
import '../modules/admin/settings/tags/tags_view.dart';
import '../modules/admin/settings/add_food_items/add_food_items_binding.dart';
import '../modules/admin/settings/add_food_items/add_food_items_view.dart';
import '../modules/admin/settings/ingredents/ingredents_binding.dart';
import '../modules/admin/settings/ingredents/ingredents_view.dart';
import '../modules/admin/settings/allergens/allergens_binding.dart';
import '../modules/admin/settings/allergens/allergens_view.dart';

class AdminRoutes {
  AdminRoutes._();

  static const adminusers = '/admin/users';
	static const adminUsers = '/admin/admin-users';
	static const menu = '/admin/menu';
	static const menuCategory = '/admin/menu-category';
	static const settings = '/admin/settings';
	static const users = '/admin/settings/users';
	static const tags = '/admin/settings/tags';
	static const addFoodItems = '/admin/settings/add-food-items';
	static const ingredents = '/admin/settings/ingredents';
	static const allergens = '/admin/settings/allergens';

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
		GetPage(
      name: menu,
      page: MenuView.new,
      binding: MenuBinding(),
    ),
		GetPage(
      name: menuCategory,
      page: MenuCategoryView.new,
      binding: MenuCategoryBinding(),
    ),
		GetPage(
      name: settings,
      page: SettingsView.new,
      binding: SettingsBinding(),
    ),
		GetPage(
      name: users,
      page: UsersView.new,
      binding: UsersBinding(),
    ),
		GetPage(
      name: tags,
      page: TagsView.new,
      binding: TagsBinding(),
    ),
		GetPage(
      name: addFoodItems,
      page: AddFoodItemsView.new,
      binding: AddFoodItemsBinding(),
    ),
		GetPage(
      name: ingredents,
      page: IngredentsView.new,
      binding: IngredentsBinding(),
    ),
		GetPage(
      name: allergens,
      page: AllergensView.new,
      binding: AllergensBinding(),
    ),
  ];
}
