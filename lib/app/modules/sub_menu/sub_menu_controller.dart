import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/menu_category.dart';

class SubMenuController extends GetxController {
  RxList<dynamic> menuItemCategory = <dynamic>[].obs;
  late final TextEditingController searchController;
  @override
  void onInit() {
    super.onInit();
    fetchMenuCategory();
    searchController = TextEditingController();
  }

  Future<void> fetchMenuCategory() async {
    final response =
        await http.get(Uri.parse('$publicCatalogBaseAddress/menu-categories'));

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
}
