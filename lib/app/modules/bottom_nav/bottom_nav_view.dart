import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../newpages/Pages/HomePage.dart';
import '../../newpages/components/colors.dart';
import '../cart/cart_page.dart';
import '../food_category/food_category_view.dart';
import '../profile/profile_view.dart';
import 'bottom_nav_controller.dart';

class BottomNavView extends GetView<BottomNavController> {
  static const String routeName = '/bottom-nav';
  BottomNavView({super.key});
  final BottomNavController logic = Get.put(BottomNavController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return PersistentTabView(
          context,
          controller:
              PersistentTabController(initialIndex: logic.currentIndex.value),
          screens: [
            Homepage(),
            FoodCategoryView(),
            CartPage(),
            ProfileView()
          ],
          items: _navBarItems(logic),
          confineToSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardAppears: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            colorBehindNavBar: Colors.white,
          ),
          onItemSelected: (index) {
            logic.changeIndex(
                index);
          },
        );
      }),
    );
  }

  List<PersistentBottomNavBarItem> _navBarItems(
      BottomNavController navController) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_outlined),
        title: "Home",
        activeColorPrimary: mainBlack,
        inactiveColorPrimary: mainBlack,
        textStyle: const TextStyle(
          fontSize: 14,
          color: mainBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.category),
        title: "Category",
        activeColorPrimary: mainBlack,
        inactiveColorPrimary: mainBlack,
        textStyle: const TextStyle(
          fontSize: 14,
          color: mainBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart_checkout_outlined),
        title: "Cart",
        activeColorPrimary: mainBlack,
        inactiveColorPrimary: mainBlack,
        textStyle: const TextStyle(
          fontSize: 14,
          color: mainBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_2_outlined),
        title: "Account",
        activeColorPrimary: mainBlack,
        inactiveColorPrimary: mainBlack,
        textStyle: const TextStyle(
          fontSize: 14,
          color: mainBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }
}
