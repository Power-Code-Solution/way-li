import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/food_items.dart';
import 'package:wayli/app/core/model/food_items_dto.dart';
import 'package:wayli/app/core/config/auth_controller.dart';

class FoodDetailController extends GetxController {
  FoodItem FIL = Get.arguments['FIL'];

  RxList<dynamic> foodandTagDto = <dynamic>[].obs;
  RxList<dynamic> foodandAllergensDto = <dynamic>[].obs;
  RxList<dynamic> foodandIngredientDto = <dynamic>[].obs;
  var price = 15.0.obs;
  var qty = 1.obs;
  var isFav = false.obs;

  // Feedback form variables
  var feedbackRating = 5.0.obs;
  var feedbackComment = ''.obs;
  var feedbackEmail = ''.obs;
  var feedbackName = ''.obs;
  var isSubmittingFeedback = false.obs;
  var feedbackSubmitSuccess = false.obs;
  var feedbackErrorMessage = ''.obs;

  void toggleFavorite() {
    isFav.value = !isFav.value;
  }

  void incrementQty() {
    qty.value++;
  }

  void decrementQty() {
    if (qty.value > 1) {
      qty.value--;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchFoodandTagDto();
    fetchFoodandAllergensDto();
    fetchFoodandIngredientDto();
    try {
      final authController = Get.find<AuthController>();
      if (authController.userEmail.value.isNotEmpty) {
        feedbackEmail.value = authController.userEmail.value;
      }
      if (authController.userName.value.isNotEmpty) {
        feedbackName.value = authController.userName.value;
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  Future<void> fetchFoodandTagDto() async {
    final url = '$publicCatalogBaseAddress/food-items/${FIL.id}/tags';
    print('Request URL: $url');

    final response = await http.get(Uri.parse(url));
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is List) {
          List<FoodandTagDto> fetchedItems = [];

          for (var item in data['data']) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                fetchedItems.add(FoodandTagDto.fromJson(item));
              } catch (e) {
                print('Error parsing item: $e');
              }
            } else {
              print('Invalid or null item encountered: $item');
            }
          }
          print('Fetched foodandTagDto items: $fetchedItems');
          if (fetchedItems.isNotEmpty) {
            foodandTagDto.value = fetchedItems;
          }
          print('Fetched foodandTagDto items: ${foodandTagDto.value}');
        } else {
          print('Invalid data format: $data');
          throw Exception('Invalid data format');
        }
      } else {
        print('Response body is empty');
        throw Exception('Response body is empty');
      }
    } else {
      print('Failed to fetch data: ${response.body}');
      throw Exception('Failed to fetch foodandTagDto items');
    }
  }

  Future<void> fetchFoodandAllergensDto() async {
    final url = '$publicCatalogBaseAddress/food-items/${FIL.id}/allergens';
    print('Request URL: $url');

    final response = await http.get(Uri.parse(url));
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is List) {
          List<FoodandAllergensDto> fetchedItems = [];

          for (var item in data['data']) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                fetchedItems.add(FoodandAllergensDto.fromJson(item));
              } catch (e) {
                print('Error parsing item: $e');
              }
            } else {
              print('Invalid or null item encountered: $item');
            }
          }
          print('Fetched foodandTagDto items: $fetchedItems');
          if (fetchedItems.isNotEmpty) {
            foodandAllergensDto.value = fetchedItems;
          }
          print('Fetched foodandTagDto items: ${foodandTagDto.value}');
        } else {
          print('Invalid data format: $data');
          throw Exception('Invalid data format');
        }
      } else {
        print('Response body is empty');
        throw Exception('Response body is empty');
      }
    } else {
      print('Failed to fetch data: ${response.body}');
      throw Exception('Failed to fetch foodandTagDto items');
    }
  }

  Future<void> fetchFoodandIngredientDto() async {
    final url = '$publicCatalogBaseAddress/food-items/${FIL.id}/ingredients';
    print('Request URL: $url');

    final response = await http.get(Uri.parse(url));
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is List) {
          List<FoodandIngredIentNameDto> fetchedItems = [];

          for (var item in data['data']) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                fetchedItems.add(FoodandIngredIentNameDto.fromJson(item));
              } catch (e) {
                print('Error parsing item: $e');
              }
            } else {
              print('Invalid or null item encountered: $item');
            }
          }
          print('Fetched foodandTagDto items: $fetchedItems');
          if (fetchedItems.isNotEmpty) {
            foodandIngredientDto.value = fetchedItems;
          }
          print('Fetched foodandTagDto items: ${foodandTagDto.value}');
        } else {
          print('Invalid data format: $data');
          throw Exception('Invalid data format');
        }
      } else {
        print('Response body is empty');
        throw Exception('Response body is empty');
      }
    } else {
      print('Failed to fetch data: ${response.body}');
      throw Exception('Failed to fetch foodandTagDto items');
    }
  }
}
