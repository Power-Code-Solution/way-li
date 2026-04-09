import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../newpages/Pages/HomePage.dart';
import '../../newpages/components/colors.dart';
import '../cart/cart_controller_fixed2.dart';
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
    final CartController cartController = Get.find<CartController>();
    return Scaffold(
      body: Obx(() {
        final int cartCount = cartController.totalCartItems;
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
          items: _navBarItems(logic, cartCount),
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
      BottomNavController navController, int cartCount) {
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
        icon: _buildCartIcon(cartCount),
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

  Widget _buildCartIcon(int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_cart_checkout_outlined),
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
