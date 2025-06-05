import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayli/app/modules/admin/admin_users/admin_users_view.dart';
import 'package:wayli/app/modules/admin/settings/menu/menu_view.dart';
import 'package:wayli/app/modules/customer/customer_profile/customer_profile_view.dart';
import 'package:wayli/app/modules/customer/order_history/order_history_view.dart';
import 'package:wayli/app/modules/customer/registration/registration_view.dart';
import 'package:wayli/app/modules/favourite_food/favourite_food_view.dart';
import 'package:wayli/app/modules/home/home_view.dart';
import 'package:wayli/app/modules/login/login_view.dart';
import 'package:wayli/app/modules/profile/profile_view.dart';

class TabsController extends GetxController {
  //TODO: Implement TabsController.

  var selectedIndex = 0.obs;
  var tabs = <Widget>[
    const HomeView(),
    const FavouriteFoodView(),
    //  const MenuView(),
    const OrderHistoryView(),
    const ProfileView()
  ].obs;
}
