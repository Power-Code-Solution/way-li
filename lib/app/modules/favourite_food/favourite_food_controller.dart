import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteFoodController extends GetxController {
  //TODO: Implement FavouriteFoodController.

  late final TextEditingController searchController;

  List popularArr = [
    {"outlets": "23", "image": "assets/images/logo1.png"},
    {"outlets": "16", "image": "assets/images/logo2.png"},
    {"outlets": "31", "image": "assets/images/logo3.png"},
    {"outlets": "60", "image": "assets/images/logo4.png"}
  ];

  List favoriteArr = [
    {"name": "Burger", "image": "assets/images/f1.png"},
    {"name": "Bread", "image": "assets/images/f2.png"},
    {"name": "Tomato", "image": "assets/images/f3.png"},
    {"name": "Fried Rice", "image": "assets/images/f4.png"},
    {"name": "Fufu", "image": "assets/images/f1.png"},
    {"name": "Burger", "image": "assets/images/f2.png"},
    {"name": "Chicken", "image": "assets/images/f3.png"},
    {"name": "Fish", "image": "assets/images/f4.png"}
  ];

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
  }
}
