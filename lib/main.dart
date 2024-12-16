import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/config/auth_controller.dart';

import 'app/core/bindings/application_bindings.dart';
import 'app/routes/app_pages.dart';

// void main() {
//   runApp(
//     GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Your App Title',
//       initialBinding: ApplicationBindings(),
//       initialRoute: AppPages.INITIAL,
//       getPages: AppPages.routes,
//     ),
//   );
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  final authController = Get.find<AuthController>();

  await authController.checkLoginStatus();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WAY LI',
      initialBinding: ApplicationBindings(),
      initialRoute: authController.isLoggedIn.value ? "/tabs" : "/login",
      getPages: AppPages.routes,
    ),
  );
}
