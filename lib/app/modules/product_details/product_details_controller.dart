import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../core/config/constants.dart';
import '../../core/model/food_items.dart';
import '../../core/model/food_items_dto.dart';

class ProductDetailsController extends GetxController {
  var itemCount = 1.obs;
  var liked = false.obs;



  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increaseCount() {
    itemCount.value++;
  }

  void decreaseCount() {
    if (itemCount.value > 1) {
      itemCount.value--;
    }
  }

  void toggleLiked() {
    liked.value = !liked.value;
  }

  FoodItem FIL = Get.arguments['FIL'];

  RxList<dynamic> foodandTagDto = <dynamic>[].obs;
  RxList<dynamic> foodandAllergensDto = <dynamic>[].obs;
  RxList<dynamic> foodandIngredientDto= <dynamic>[].obs;
  var price = 15.0.obs;
  var qty = 1.obs;
  var isFav = false.obs;

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
  }



  Future<void> fetchFoodandTagDto() async {
    final url =
        '$apiBaseAddress/secure/admin/food-items/findForTags-byfkFoodItemId?id=${FIL.id}';
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
          print('Invalid data format: ${data}');
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
    final url =
        '$apiBaseAddress/secure/admin/food-items/findForAllergens-byfkFoodItemId?id=${FIL.id}';
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
          print('Invalid data format: ${data}');
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
    final url =
        '$apiBaseAddress/secure/admin/food-items/findby-fkingredientId?id=${FIL.id}';
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
          print('Invalid data format: ${data}');
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
