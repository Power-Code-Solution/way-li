import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/modules/admin/admin_users/admin_users_view.dart';
import 'package:wayli/app/modules/customer/order_history/order_history_view.dart';
import 'package:wayli/app/modules/customer/registration/registration_view.dart';
import 'package:wayli/app/modules/home/home_view.dart';
import 'package:wayli/app/modules/login/login_view.dart';
import 'package:wayli/app/modules/profile/profile_view.dart';
import 'package:wayli/app/modules/splash_screen/splash_screen_view.dart';
import 'tabs_controller.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';



class TabsView extends GetView<TabsController> {
  static String routeName = "/tabs";
   final GlobalKey bottomNavigationKey;
  const TabsView({super.key, required this.bottomNavigationKey});

  @override
  Widget build(BuildContext context) {
final List<String> iconPaths = [
      'assets/svg/dashboard.svg',
      'assets/svg/favourite.svg',
      'assets/svg/history.svg',
      'assets/svg/setting.svg',
    ];
 
final List<Widget> screens = [
   const HomeView(),
  const AdminUsersView(),
  const OrderHistoryView(),
  const ProfileView()
    ];
   final TabsController tabsController = Get.put(TabsController());
     return Scaffold(
      extendBody: true,
      floatingActionButton: Padding(
      padding: const EdgeInsets.all(0),
      
      child: FloatingActionButton(
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        onPressed: () {
          Get.to( SplashScreenView());
        },
        
        child: SvgPicture.asset(
          'assets/svg/addition.svg',
          color: secondaryColor,
          height: 30,
          width: 30,
        ),
      ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Obx(() => screens[tabsController.selectedIndex.value]),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: secondaryColor,
        key: bottomNavigationKey,
        items: List<Widget>.generate(iconPaths.length, (index) {
          return SvgPicture.asset(
            iconPaths[index],
            height: 30,
            width: 30,
            color: primaryColor,
          );
        }),
        onTap: (index) {
          tabsController.selectedIndex.value = index;
        },
      ),
    );
  }
}
