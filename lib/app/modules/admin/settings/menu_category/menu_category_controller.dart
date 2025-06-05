import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/menu.dart';
import 'package:wayli/app/core/model/menu_category.dart';

class MenuCategoryController extends GetxController {
  var isLoading = false.obs;
  var responseMessage = ''.obs;
  RxList<dynamic> menuItemCategory = <dynamic>[].obs;
  var selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchMenuCategory();
  }

  Future<void> createMenuCategory(
      String name, String fkMenuId, String description, File? menuFile) async {
    isLoading.value = true;
    if (name.isEmpty || description.isEmpty || menuFile == null) {
      responseMessage.value = 'All fields are required.';
      Get.snackbar('Error', 'Please provide a name, description, and an image.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      isLoading.value = false;
      return;
    }
    try {
      var uri = Uri.parse('$apiBaseAddress/secure/admin/menu-category/create');
      var request = http.MultipartRequest('POST', uri)
        ..fields['Name'] = name
        ..fields['FkMenuId'] = fkMenuId
        ..fields['Description'] = description;
      var mimeType = lookupMimeType(menuFile.path);
      var fileStream = http.ByteStream(menuFile.openRead());
      var fileLength = await menuFile.length();
      var multipartFile = http.MultipartFile(
        'menuCategoryFile',
        fileStream,
        fileLength,
        filename: basename(menuFile.path),
        contentType: mimeType != null
            ? MediaType('image', mimeType.split('/')[1])
            : MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);
      request.headers['accept'] = '*/*';
      request.headers['Content-Type'] = 'multipart/form-data';
      var response = await request.send();
      if (response.statusCode == 201) {
        responseMessage.value = 'Menu created successfully!';
        Get.snackbar('Success', 'Menu created successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        responseMessage.value =
            'Failed to create menu. Status: ${response.statusCode}';
        Get.snackbar('Error', 'Failed to create menu. Please try again.',
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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    } else {
      print("No image selected.");
    }
  }

  Future<void> fetchMenuCategory() async {
    final response =
        await http.get(Uri.parse('$apiBaseAddress/secure/admin/menu/all'));

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        if (data['data'] != null && data['data'] is List) {
          List<Menu> fetchedItems = [];
          for (var item in data['data']) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                fetchedItems.add(Menu.fromJson(item));
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

  int? menuCategoryId;

  selectedMenuCategory(val) {
    var selectedMenuCategory = menuItemCategory.value.firstWhere(
      (menuItem) => menuItem.name == val,
      orElse: () => Menu(
          id: -1,
          name: val,
          description: '',
          coverImage: '',
          active: false,
          deleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          deletedAt: DateTime.now()),
    );
    menuCategoryId = selectedMenuCategory.id;
    print("Selected commune ID: $menuCategoryId");
  }
}
