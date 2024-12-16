import 'package:get/get.dart';

class FoodDetailController extends GetxController {
  //TODO: Implement FoodDetailController.

late final Map FIL;

List trendingArr = [
    {
      "name": "Seafood Lee",
      "address": "210 Salt Pond Rd.",
      "category": "Seafood, Spain",
      "image": "assets/images/food.png"
    },
    {
      "name": "Egg Tomato",
      "address": "East 46th Street",
      "category": "Egg, Italian",
      "image": "assets/images/t2.png"
    },
    {
      "name": "Burger Hot",
      "address": "East 46th Street",
      "category": "Pizza, Italian",
      "image": "assets/images/t3.png"
    }
  ];
  List collectionsArr = [
    {"name": "Legendary food", "place": "34", "image": "assets/images/c1.png"},
    {"name": "Seafood", "place": "28", "image": "assets/images/c2.png"},
    {"name": "Fizza Meli", "place": "56", "image": "assets/images/c3.png"}
  ];


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
