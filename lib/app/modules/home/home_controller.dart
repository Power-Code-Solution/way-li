import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController.

  late final TextEditingController searchController;
  late final FocusNode focusNode;
 

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

List legendaryArr = [
    {
      "name": "Lombar Pizza",
      "address": "Rodin Street",
      "category": "Pizza",
      "image": "assets/images/food.png"
    },
    {
      "name": "Sushi Bar",
      "address": "Rodin Street.",
      "category": "Sushi",
      "image": "assets/images/l2.png"
    },
    {
      "name": "Steak House",
      "address": "Rodin Street",
      "category": "Steak",
      "image": "assets/images/l3.png"
    }
  ];
  List trendingArr = [
    {
      "name": "Seafood Lee",
      "address": "Rodin Street",
      "category": "Seafood",
      "image": "assets/images/t1.png"
    },
    {
      "name": "Egg Tomato",
      "address": "Rodin Street",
      "category": "Egg",
      "image": "assets/images/t2.png"
    },
    {
      "name": "Burger Hot",
      "address": "Rodin Street",
      "category": "Pizza",
      "image": "assets/images/t3.png"
    }
  ];
  List collectionsArr = [
    {"name": "Legendary food", "place": "34", "image": "assets/images/c1.png"},
    {"name": "Seafood", "place": "28", "image": "assets/images/c2.png"},
    {"name": "Fizza Meli", "place": "56", "image": "assets/images/c3.png"}
  ];

  List favoriteArr = [
    {"name": "Rodin Street", "image": "assets/images/f1.png"},
    {"name": "Rodin Street", "image": "assets/images/f2.png"},
    {"name": "Rodin Street", "image": "assets/images/f3.png"},
    {"name": "Rodin Street", "image": "assets/images/f4.png"},
    {"name": "Rodin Street", "image": "assets/images/f1.png"},
    {"name": "Rodin Street", "image": "assets/images/f2.png"},
    {"name": "Rodin Street", "image": "assets/images/f3.png"},
    {"name": "Rodin Street", "image": "assets/images/f4.png"}
  ];

  List popularArr = [
    {"outlets": "PIZA", "image": "assets/images/way-li_logo.png"},
    {"outlets": "BURGUR", "image": "assets/images/way-li_logo.png"},
    {"outlets": "SAWAMA", "image": "assets/images/way-li_logo.png"},
    {"outlets": "CHICKEN", "image": "assets/images/way-li_logo.png"}
  ];




}
