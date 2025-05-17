import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/modules/home/home_controller.dart';

import 'app/core/bindings/application_bindings.dart';
import 'app/modules/cart/cart_controller.dart';
import 'app/modules/food_category/food_category_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    Get.put(AuthController());
    Get.put(FoodCategoryController());
    Get.put(HomeController());
    Get.put(CartController());

    final authController = Get.find<AuthController>();
    await authController.checkLoginStatus();

    runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WAY LI',
        initialBinding: ApplicationBindings(),
        initialRoute: authController.isLoggedIn.value ? "/bottom-nav" : "/login",
        getPages: AppPages.routes,
      ),
    );
  } catch (e, stackTrace) {
    print("Error in main(): $e");
    print("This is the stack trace ${stackTrace}" );
  }
}


