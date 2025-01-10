		

		// ignore_for_file: constant_identifier_names
		
import 'home_routes.dart';
import 'customer_routes.dart';
import 'login_routes.dart';
import 'tabs_routes.dart';
import 'admin_routes.dart';
import 'splash_screen_routes.dart';
import 'forget_password_routes.dart';
import 'otp_routes.dart';
import 'profile_routes.dart';
import 'on_boarding_routes.dart';
import 'food_detail_routes.dart';
import 'favourite_food_routes.dart';
import 'sub_menu_food_routes.dart';
import 'sub_menu_routes.dart';
import 'history_routes.dart';


class AppPages {
  AppPages._();

  static const INITIAL = '/splash-screen';

  static final routes = [
    ...SplashScreenRoutes.routes,
    ...HomeRoutes.routes,
		...CustomerRoutes.routes,
		...LoginRoutes.routes,
		...TabsRoutes.routes,
		...AdminRoutes.routes,
		...ForgetPasswordRoutes.routes,
		...OtpRoutes.routes,
		...ProfileRoutes.routes,
		...OnBoardingRoutes.routes,
		...FoodDetailRoutes.routes,
		...FavouriteFoodRoutes.routes,
		...SubMenuFoodRoutes.routes,
		...SubMenuRoutes.routes,
		...HistoryRoutes.routes,
  ];
}
