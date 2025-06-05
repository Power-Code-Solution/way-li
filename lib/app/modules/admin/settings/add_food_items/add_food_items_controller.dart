import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:path/path.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/allergenss.dart';
import 'package:wayli/app/core/model/ingredents.dart';
import 'package:wayli/app/core/model/menu_category.dart';
import 'package:wayli/app/core/model/tag.dart';

class AddFoodItemsController extends GetxController {
  //TODO: Implement AddFoodItemsController.
  int? menuCategoryId;
  int? foodItemsAllergensId;
  int? foodItemsIngredentsId;
  var isLoading = false.obs;
  var responseMessage = ''.obs;
  var selectedImages = RxList<File>([]);
  RxList<dynamic> menuItemCategory = <dynamic>[].obs;
  var tagsItems = <DropdownItem<Tag>>[].obs;
  var ingredientsItemsList = <DropdownItem<Ingredents>>[].obs;
  var allergensItemsList = <DropdownItem<Allergens>>[].obs;

  var fkTagIds = <int>[].obs;
  var fkAllergensId = <int>[].obs;
  var fkIngredientsId = <int>[].obs;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final fkMenuCategoryIdController = TextEditingController();
  final typeController = TextEditingController();
  final priceController = TextEditingController();
  final servingSize = TextEditingController();
  final ingredients = TextEditingController();
  final allergens = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchIngredients();
    fetchAllergens();
    fetchMenuCategory();
    fetchTags();
  }

  Future<void> createMenu(
    String name,
    String description,
    String type,
    String fkMenuCategoryId,
    String servingSize,
    String price,
    List<File> images,
    List<int> fkTagIds,
    List<int> fkAllergensId,
    List<int> fkIngredientsId,
  ) async {
    if (name.isEmpty ||
        description.isEmpty ||
        fkMenuCategoryId.isEmpty ||
        type.isEmpty ||
        servingSize.isEmpty ||
        images.isEmpty ||
        fkTagIds.isEmpty ||
        price.isEmpty) {
      responseMessage.value = 'All fields are required.';
      Get.snackbar(
          'Error', 'Please provide name, description, tags, and images.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      var uri = Uri.parse('$apiBaseAddress/secure/admin/food-items/create');
      var request = http.MultipartRequest('POST', uri)
        ..fields['Name'] = name
        ..fields['Description'] = description
        ..fields['Type'] = type
        ..fields['FkMenuCategoryId'] = fkMenuCategoryId
        ..fields['ServingSize'] = servingSize
        ..fields['Price'] = price;

      print("Received FkTagIds: $fkTagIds");

      for (var image in images) {
        var mimeType = lookupMimeType(image.path);
        var fileStream = http.ByteStream(image.openRead());
        var fileLength = await image.length();
        var multipartFile = http.MultipartFile(
          'FoodItemFiles',
          fileStream,
          fileLength,
          filename: basename(image.path),
          contentType: mimeType != null
              ? MediaType('image', mimeType.split('/')[1])
              : MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      request.fields['FkTagIds'] = fkTagIds.join(',');
      request.fields['fkAllergensId'] = fkAllergensId.join(',');
      request.fields['fkIngredientsId'] = fkIngredientsId.join(',');
      print("Request sent to the server:");
      print("URI: $uri");
      print("Fields:");
      request.fields.forEach((key, value) {
        print('$key: $value');
      });

      var response = await request.send();
      if (response.statusCode == 201) {
        responseMessage.value = 'Menu created successfully!';
        Get.snackbar('Success', 'Menu created successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        resetForm();
      } else {
        responseMessage.value =
            'Failed to create menu. Status: ${response.statusCode}';
        var responseBody = await response.stream.bytesToString();
        print("Server Response: $responseBody");
      }
    } catch (e) {
      responseMessage.value = 'Error: $e';
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    nameController.clear();
    descriptionController.clear();
    typeController.clear();
    fkMenuCategoryIdController.clear();
    servingSize.clear();
    priceController.clear();
    fkTagIds.clear();
    fkAllergensId.clear();
    fkIngredientsId.clear();
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
    } else {
      print("No images selected.");
    }
  }

  void removeImage(File file) {
    selectedImages.remove(file);
  }

  Future<void> fetchMenuCategory() async {
    final response = await http
        .get(Uri.parse('$apiBaseAddress/secure/admin/menu-category/all'));

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

  selectedMenuCategory(val) {
    var selectedMenuCategory = menuItemCategory.value.firstWhere(
      (menuItem) => menuItem.name == val,
      orElse: () => MenuCategory(
          id: -1,
          fkMenuId: -1,
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

  Future<void> fetchTags() async {
    final response =
        await http.get(Uri.parse('$apiBaseAddress/secure/admin/tags/all'));
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        print('Decoded data: $data');
        if (data['data'] != null && data['data'] is List) {
          List<DropdownItem<Tag>> tagsItemsList = [];
          for (var item in data['data']) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                var tag = Tag.fromJson(item);
                tagsItemsList.add(DropdownItem(label: tag.name, value: tag));
                print('DropdownItem added: $tagsItemsList');
              } catch (e) {
                print('Error parsing tag: $e');
              }
            }
          }
          tagsItems.value = tagsItemsList;
          print('Items populated: ${tagsItems.length}');
        }
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<void> fetchAllergens() async {
    final response = await http
        .get(Uri.parse('$apiBaseAddress/secure/admin/allergenss/all'));
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        print('Decoded data: $data');
        if (data['data'] != null && data['data'] is List) {
          List<DropdownItem<Allergens>> allergensItemsList = [];
          for (var item in data['data']) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                var tag = Allergens.fromJson(item);
                allergensItemsList
                    .add(DropdownItem(label: tag.name, value: tag));
                print('DropdownItem added: $allergensItemsList');
              } catch (e) {
                print('Error parsing tag: $e');
              }
            }
          }
          this.allergensItemsList.value = allergensItemsList;
          print('Items populated: ${allergensItemsList.length}');
        }
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<void> fetchIngredients() async {
    final response = await http
        .get(Uri.parse('$apiBaseAddress/secure/admin/ingredients/all'));
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        print('Decoded data: $data');
        if (data['data'] != null && data['data'] is List) {
          List<DropdownItem<Ingredents>> ingredientsItemsList = [];
          for (var item in data['data']) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                var tag = Ingredents.fromJson(item);
                ingredientsItemsList
                    .add(DropdownItem(label: tag.name, value: tag));
                print('DropdownItem added: $ingredientsItemsList');
              } catch (e) {
                print('Error parsing tag: $e');
              }
            }
          }
          this.ingredientsItemsList.value = ingredientsItemsList;
          print('Items populated: ${ingredientsItemsList.length}');
        }
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }
}
