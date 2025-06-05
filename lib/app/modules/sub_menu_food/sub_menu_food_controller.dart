import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/food_items.dart';
import 'package:wayli/app/core/model/menu_category.dart';

class SubMenuFoodController extends GetxController {
  MenuCategory menuItemCategory = Get.arguments["menuItemCategory"];
  RxList<dynamic> foodItems = <dynamic>[].obs;
  late final TextEditingController searchController;

  @override
  void onInit() {
    super.onInit();
    fetchFoodItems();

    if (kDebugMode) {
      print(
          "OutletController onInit() has been called. ${menuItemCategory.coverImage}");
    }
    if (kDebugMode) {
      print(
          "$menuItemCategory + This is the menu item received from the home controller");
    }
    searchController = TextEditingController();
  }

  Future<void> fetchFoodItems() async {
    final response = await http.get(Uri.parse(
        '$apiBaseAddress/secure/admin/food-items/findby-fkMenuCategoryId?FkMenuCategoryId=${menuItemCategory.id}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null && data['data'] is List) {
        List<FoodItem> fetchedItems = List<FoodItem>.from(
          data['data'].map((item) => FoodItem.fromJson(item)),
        );
        foodItems.value = fetchedItems;
        print('Fetched food items: ${foodItems.toList()}');
      } else {
        print('Fetched food items_____+++++: ${foodItems.toList()}');
        throw Exception('Invalid data format');
      }
    } else {
      print('Fetched food items__________: ${foodItems.toList()}');
      throw Exception('Failed to fetch food items');
    }
  }
}
