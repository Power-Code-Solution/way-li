import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:wayli/app/newpages/Pages/Account.dart';
import 'package:wayli/app/newpages/Pages/Cart.dart' show CartScreen;
import 'package:wayli/app/newpages/Pages/Category.dart';
import 'package:wayli/app/newpages/Pages/Explore.dart';
import 'package:wayli/app/newpages/Pages/HomePage.dart';
import 'package:wayli/app/newpages/components/colors.dart';

class BottomBarMain extends StatefulWidget {
  const BottomBarMain({super.key});

  @override
  State<BottomBarMain> createState() => _BottomBarMainState();
}

class _BottomBarMainState extends State<BottomBarMain> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: [
          Homepage(),
          Category(),
          ExplorePage(),
          CartScreen(),
          AccountScreen()
        ],
        items: _navBarItems(),
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
            colorBehindNavBar: Colors.white),
      ),
    );
  }
}

List<PersistentBottomNavBarItem> _navBarItems() {
  return [
    PersistentBottomNavBarItem(
        icon: Icon(Icons.home_outlined),
        title: ("Home"),
        activeColorPrimary: mainYellow,
        inactiveColorPrimary: mainBlack,
        routeAndNavigatorSettings:
            RouteAndNavigatorSettings(initialRoute: "/")),
    PersistentBottomNavBarItem(
        icon: Icon(Icons.category),
        title: ("Category"),
        activeColorPrimary: mainYellow,
        inactiveColorPrimary: mainBlack,
        routeAndNavigatorSettings:
            RouteAndNavigatorSettings(initialRoute: "/category")),
    PersistentBottomNavBarItem(
        icon: Icon(Icons.explore),
        title: ("Explore"),
        activeColorPrimary: mainYellow,
        inactiveColorPrimary: mainBlack,
        routeAndNavigatorSettings:
            RouteAndNavigatorSettings(initialRoute: "/explore")),
    PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart_checkout_outlined),
        title: ("Category"),
        activeColorPrimary: mainYellow,
        inactiveColorPrimary: mainBlack,
        routeAndNavigatorSettings:
            RouteAndNavigatorSettings(initialRoute: "/productdetails")),
    PersistentBottomNavBarItem(
        icon: Icon(Icons.person_2_outlined),
        title: ("Account"),
        activeColorPrimary: mainYellow,
        inactiveColorPrimary: mainBlack,
        routeAndNavigatorSettings:
            RouteAndNavigatorSettings(initialRoute: "/cart"))
  ];
}
