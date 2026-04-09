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
  RxBool loading = true.obs;
  RxList<dynamic> foodItems = <dynamic>[].obs;
  RxList<dynamic> menuItems = <dynamic>[].obs;
  RxList<dynamic> menuItemCategory = <dynamic>[].obs;
  final List<FoodItem> _originalFoodItems = [];

  @override
  void onInit() {
    loading.value = true;
    super.onInit();
    fetchFoodItems();
    fetchMenuCategory();
    searchController = TextEditingController();
  }

  Future<void> refreshButton() async {
    loading.value = true;
    fetchFoodItems();
    fetchMenuCategory();
  }

  String get dayOfTheWeek {
    List<String> days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    return days[DateTime.now().weekday % 7];
  }

  void filterFoodItems(String query) {
    if (query.isEmpty) {
      foodItems.value = List.from(_originalFoodItems);
    } else {
      foodItems.value = _originalFoodItems
          .where(
              (item) => item?.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }

  Future<void> fetchFoodItems() async {
    try {
      loading.value = true;
      final response = await http
          .get(Uri.parse('$apiBaseAddress/secure/admin/food-items/all'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data'); // Debugging line

        if (data['data'] != null && data['data'] is List) {
          List<FoodItem>? fetchedItems = List<FoodItem>.from(
            data['data'].map((item) {
              print('Item: $item'); // Debugging line
              return FoodItem.fromJson(item);
            }),
          );

          foodItems.assignAll(fetchedItems);
          _originalFoodItems.assignAll(fetchedItems);
          foodItems.value = List.from(_originalFoodItems);
          loading.value = false;
          update();
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to fetch food items');
      }
    } catch (e) {
      loading.value = false;
      print('Error fetching food items For All Items: $e');
    }
  }

  Future<void> fetchMenuItems() async {
    if (menuItems.isNotEmpty) return;
    loading.value = true;
    update();
    try {
      final response =
          await http.get(Uri.parse('$apiBaseAddress/secure/admin/menu/all'));
      if (response.statusCode == 200) {
        loading.value = false;
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is List) {
          List<Menu> fetchedItems = List<Menu>.from(
            data['data'].map((item) => Menu.fromJson(item)),
          );
          menuItems.value = fetchedItems;
          print('Fetched food items: ${menuItems.value}');
        } else {
          loading.value = false;
          throw Exception('Invalid Menu format');
        }
      } else {
        throw Exception('Failed to fetch food items');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
    } finally {
      loading.value = false;
      update();
    }
  }

  Future<void> fetchMenuCategory() async {
    final response = await http
        .get(Uri.parse('$apiBaseAddress/secure/admin/menu-category/all'));
    loading.value = true;
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        loading.value = false;
        if (data['data'] != null && data['data'] is List) {
          List<MenuCategory> fetchedItems = [];
          for (var item in data['data']) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                fetchedItems.add(MenuCategory.fromJson(item));
              } catch (e) {
                loading.value = false;
                print('Error parsing item: $e');
              }
            } else {
              loading.value = false;
              print('Invalid or null item encountered: $item');
            }
          }

          print('Fetched Menu Category items: $fetchedItems');
          if (fetchedItems.isNotEmpty) {
            menuItemCategory.value = fetchedItems;
            loading.value = false;
          }
          print('Fetched Menu Category items: ${menuItemCategory.value}');
        } else {
          loading.value = false;
          print('Invalid data format: $data');
          throw Exception('Invalid data format');
        }
      } else {
        loading.value = false;
        print('Response body is empty');
        throw Exception('Response body is empty');
      }
    } else {
      loading.value = false;
      print('Failed to fetch data: ${response.statusCode}');
      throw Exception('Failed to fetch Menu Category items');
    }
  }
}
