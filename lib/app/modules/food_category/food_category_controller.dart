import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/food_items.dart';
import 'package:wayli/app/core/model/menu.dart';
import 'package:wayli/app/core/model/menu_category.dart';
import 'package:wayli/app/core/model/user_model.dart';
import 'package:http/http.dart' as http;

class FoodCategoryController extends GetxController {
  // var selectedCategoryIndex = Rx<int?>(null);
  var selectedCategoryIndex = (-1).obs;
  late final TextEditingController searchController;
  RxBool isLoading = false.obs;
  RxList<dynamic> foodItems = <dynamic>[].obs;
  RxList<dynamic> allFoodItems = <dynamic>[].obs;
  // RxList<dynamic> menuItems = <dynamic>[].obs;
  RxList<Menu> menuItems = <Menu>[].obs;
  // RxList<dynamic> menuItemCategory = <dynamic>[].obs;
  RxList<MenuCategory> menuItemCategory = <MenuCategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMenuCategory();
    fetchFoodItems(-1);
    fetchAllFoodItems();
    fetchMenuItems();
    searchController = TextEditingController();
  }


  Future<void> refreshButton() async {
    fetchMenuCategory();
    fetchAllFoodItems();
    fetchMenuItems();
  }

  Future<void> fetchFoodItems(int categoryId) async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$apiBaseAddress/secure/admin/food-items/findby-fkMenuCategoryId?FkMenuCategoryId=$categoryId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is List) {
          List<FoodItem> fetchedItems = List<FoodItem>.from(data['data'].map((item) => FoodItem.fromJson(item)));
          foodItems.assignAll(fetchedItems); // Use assignAll for reactive updates
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to fetch food items');
      }
    } catch (e) {
      print('Error fetching food items: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchAllFoodItems() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$apiBaseAddress/secure/admin/food-items/all'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is List) {
          List<FoodItem> fetchedItems = List<FoodItem>.from(data['data'].map((item) => FoodItem.fromJson(item)));
          allFoodItems.value = fetchedItems;
          foodItems.assignAll(fetchedItems);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to fetch all food items');
      }
    } catch (e) {
      print('Error fetching all food items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMenuItems() async {
    if (menuItems.isNotEmpty) return;

    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$apiBaseAddress/secure/admin/menu/all'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is List) {
          List<Menu> fetchedItems = List<Menu>.from(
            data['data'].map((item) => Menu.fromJson(item)),
          );
          menuItems.value = fetchedItems;
          update();  // Trigger UI update after fetching menu items
        } else {
          throw Exception('Invalid Menu format');
        }
      } else {
        throw Exception('Failed to fetch food items');
      }
    } catch (e) {
      print('Error fetching menu items: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchMenuCategory() async {
    var url = ('$apiBaseAddress/secure/admin/menu-category/all');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("I was pressed to return data and I returned the data: ${response.body}");

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
            }
          }

          // Insert "All" category manually
          fetchedItems.insert(
            0,
            MenuCategory(
              id: -1,
              name: 'All',
              fkMenuId: 0,
              description: '',
              coverImage: '',
              active: true,
              deleted: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              deletedAt: DateTime.now(),
            ),
          );

          // Only update menuItemCategory (correctly typed)
          menuItemCategory.assignAll(fetchedItems);

          update(); // If using GetxController
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

  void setCategory(int? categoryId) async {
    print("Selected Category: $categoryId");

    selectedCategoryIndex.value = categoryId!;


    if (categoryId == -1) {
      await fetchAllFoodItems();
      print("Fetched All Food Items: $allFoodItems");
      foodItems.value = List.from(allFoodItems);
    } else {
      fetchFoodItems(categoryId!);
    }

    print("Updated Food Items: $foodItems");
  }


  void filterFoodItems(String query) {
    if (query.isEmpty) {
      foodItems.value = List.from(allFoodItems);
    } else {
      foodItems.value = allFoodItems
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }



}
