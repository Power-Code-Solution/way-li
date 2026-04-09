import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/tag.dart';

class TagsController extends GetxController {
  var isLoading = false.obs;
  var responseMessage = ''.obs;
  RxList<dynamic> tag = <dynamic>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchTag();
  }

  Future<void> createTag(String name) async {
    isLoading.value = true;

    if (name.isEmpty) {
      responseMessage.value = 'All fields are required.';
      Get.snackbar('Error', 'Please provide a tag name',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      isLoading.value = false;
      return;
    }
    try {
      var uri = Uri.parse('$apiBaseAddress/secure/admin/tags/create');
      var body = json.encode({
        'name': name,
      });
      print('[DEBUG_LOG] POST ' + uri.toString());
      print('[DEBUG_LOG] Headers: {Content-Type: application/json}');
      print('[DEBUG_LOG] Payload: ' + body);
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        fetchTag();
        responseMessage.value = 'Tag created successfully!';
        Get.snackbar('Success', 'Tag created successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        responseMessage.value =
            'Failed to create menu. Status: ${response.statusCode}';
        Get.snackbar('Error',
            'Failed to create Tags. Please try again. $responseMessage',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      responseMessage.value = 'Error: $e';
      Get.snackbar('Error', 'An error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTag() async {
    final response =
        await http.get(Uri.parse('$apiBaseAddress/secure/admin/menu/all'));

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        if (data['data'] != null && data['data'] is List) {
          List<Tag> fetchedItems = [];
          for (var item in data['data']) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                fetchedItems.add(Tag.fromJson(item));
              } catch (e) {
                print('Error parsing item: $e');
              }
            } else {
              print('Invalid or null item encountered: $item');
            }
          }

          print('Fetched Tag Category items: $fetchedItems');
          if (fetchedItems.isNotEmpty) {
            tag.value = fetchedItems;
          }
          print('Fetched Tag Category items: ${tag.value}');
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
      throw Exception('Failed to fetch Tag Category items');
    }
  }
}
