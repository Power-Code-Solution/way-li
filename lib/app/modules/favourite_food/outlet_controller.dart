import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/menu.dart';
import 'package:wayli/app/core/model/menu_category.dart';

class OutletController extends GetxController {
  var outletArr = <Map<String, dynamic>>[].obs;

  Menu menuItem = Get.arguments["menuItems"];
  RxList<dynamic> menuItemCategory = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenuCategory();
    if (kDebugMode) {
      print(
          "OutletController onInit() has been called. ${menuItem.coverImage}");
    }
    if (kDebugMode) {
      print(
          "$menuItem + This is the menu item received from the home controller");
    }
  }

  Future<void> fetchMenuCategory() async {
    final response = await http.get(
        Uri.parse('$publicCatalogBaseAddress/menus/${menuItem.id}/categories'));

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
          print('Invalid data format: $data');
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

  void fetchOutlets() {
    outletArr.value = [
      {
        "name": "Lombar Pizza",
        "address": "East 46th Street",
        "category": "Pizza, Italian",
        "image": "assets/images/l1.png",
        "time": "11:30AM to 11:00PM",
        "rate": 4.8
      },
      {
        "name": "Sushi Bar",
        "address": "210 Salt Pond Rd.",
        "category": "Sushi, Japan",
        "image": "assets/images/l2.png",
        "time": "11:30AM to 11:00PM",
        "rate": 3.8
      },
      {
        "name": "Steak House",
        "address": "East 46th Street",
        "category": "Steak, American",
        "image": "assets/images/l3.png",
        "time": "11:30AM to 11:00PM",
        "rate": 2.8
      },
      {
        "name": "Seafood Lee",
        "address": "210 Salt Pond Rd.",
        "category": "Seafood, Spain",
        "image": "assets/images/t1.png",
        "time": "11:30AM to 11:00PM",
        "rate": 5.0
      },
      {
        "name": "Egg Tomato",
        "address": "East 46th Street",
        "category": "Egg, Italian",
        "image": "assets/images/t2.png",
        "time": "11:30AM to 11:00PM",
        "rate": 4.8
      },
      {
        "name": "Burger Hot",
        "address": "East 46th Street",
        "category": "Pizza, Italian",
        "image": "assets/images/t3.png",
        "time": "11:30AM to 11:00PM",
        "rate": 4.8
      }
    ];
  }
}
