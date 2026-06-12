import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/modules/customer/order_history/order_history_controller.dart';
import 'package:wayli/app/modules/home/home_controller.dart';
import 'package:wayli/app/modules/product_details/product_details_controller.dart';
import 'app/core/bindings/application_bindings.dart';
import 'app/modules/cart/cart_controller_fixed2.dart';
import 'app/modules/food_category/food_category_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasOnboarded = prefs.getBool('hasOnboarded') ?? false;
  try {
    final authController = Get.put(AuthController(), permanent: true);
    Get.put(FoodCategoryController());
    Get.put(HomeController());
    Get.put(CartController());
    Get.put(OrderHistoryController());
    Get.put(ProductDetailsController());
    await authController.checkLoginStatus();
    runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WAY LI',
        initialBinding: ApplicationBindings(),
        initialRoute: !hasOnboarded ? "/on-boarding" : "/bottom-nav",
        getPages: AppPages.routes,
      ),
    );
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print("Error in main(): $e");
    }
    if (kDebugMode) {
      print("This is the stack trace $stackTrace");
    }
  }
}
