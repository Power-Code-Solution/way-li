import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/food_items.dart';
import 'package:wayli/app/core/model/menu.dart';
import 'package:wayli/app/core/model/menu_category.dart';
import 'package:wayli/app/core/model/user_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  //TODO: Implement HomeController.

  late final TextEditingController searchController;
  late final FocusNode focusNode;
  bool isLoading = false; 
  RxList<dynamic> foodItems = <dynamic>[].obs;
  RxList<dynamic> menuItems = <dynamic>[].obs;
  RxList<dynamic> menuItemCategory = <dynamic>[].obs;
  
  
  @override
  void onInit() {
    super.onInit();
    fetchMenuItems();
    fetchFoodItems();
    fetchMenuCategory();
    searchController = TextEditingController();
  }


  Future<void> refreshButton() async {
    fetchMenuItems();
    fetchFoodItems();
    fetchMenuCategory();
  }




  @override
  void onReady() {
    super.onReady();
  }

String get dayOfTheWeek {
    List<String> days = [
      "Sunday", "Monday", "Tuesday", "Wednesday", 
      "Thursday", "Friday", "Saturday"
    ];
    return days[DateTime.now().weekday % 7]; 
  }

  Future<void> fetchFoodItems() async {
    final response = await http
        .get(Uri.parse('$apiBaseAddress/secure/admin/food-items/all'));
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

Future<void> fetchMenuItems() async {
    if (menuItems.isNotEmpty) return;

    isLoading = true;
    update();

    try {
      final response = await http.get(Uri.parse('$apiBaseAddress/secure/admin/menu/all'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is List) {
          List<Menu> fetchedItems = List<Menu>.from(
            data['data'].map((item) => Menu.fromJson(item)),
          );
          menuItems.value = fetchedItems;
          print('Fetched food items: ${menuItems.value}');
        } else {
          throw Exception('Invalid Menu format');
        }
      } else {
        throw Exception('Failed to fetch food items');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  // Future<void> fetchMenuItems() async {
  //   final response =
  //       await http.get(Uri.parse('$apiBaseAddress/secure/admin/menu/all'));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     if (data['data'] != null && data['data'] is List) {
  //       List<Menu> fetchedItems = List<Menu>.from(
  //         data['data'].map((item) => Menu.fromJson(item)),
  //       );
  //       menuItems.value = fetchedItems;
  //       print('Fetched food items: ${menuItems.value}');
  //     } else {
  //       print('Fetched Menu  items_____+++++: ${menuItems.value}');
  //       throw Exception('Invalid Menu format');
  //     }
  //   } else {
  //     print('Fetched food items__________: ${menuItems.value}');
  //     throw Exception('Failed to fetch food items');
  //   }
  // }

Future<void> fetchMenuCategory() async {
  final response = await http.get(Uri.parse('$apiBaseAddress/secure/admin/menu-category/all'));

  if (response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      final data = jsonDecode(response.body);

      if (data['data'] != null && data['data'] is List) {
        List<MenuCategory> fetchedItems = [];
        for (var item in data['data']) {
          if (item != null && item is Map<String, dynamic>) {
            try {
              fetchedItems.add(MenuCategory.fromJson(item));
            } catch (e) {
              print('Error parsing item: $e');
            }
          } else {
            print('Invalid or null item encountered: $item');
          }
        }

        print('Fetched Menu Category items: $fetchedItems');
        if (fetchedItems.isNotEmpty) {
          menuItemCategory.value = fetchedItems;
        }
        print('Fetched Menu Category items: ${menuItemCategory.value}');
      } else {
        print('Invalid data format: ${data}');
        throw Exception('Invalid data format');
      }
    } else {
      print('Response body is empty');
      throw Exception('Response body is empty');
    }
  } else {
    print('Failed to fetch data: ${response.statusCode}');
    throw Exception('Failed to fetch Menu Category items');
  }
}


}
