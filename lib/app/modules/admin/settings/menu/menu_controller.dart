import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:wayli/app/core/config/constants.dart';

class AddMenuController extends GetxController {
  var isLoading = false.obs;
  var responseMessage = ''.obs;
  var selectedImage = Rx<File?>(null);
  Future<void> createMenu(
      String name, String description, File? menuFile) async {
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
      var uri = Uri.parse('$apiBaseAddress/secure/admin/menu/create');
      var request = http.MultipartRequest('POST', uri)
        ..fields['Name'] = name
        ..fields['Description'] = description;
      var mimeType = lookupMimeType(menuFile.path);
      var fileStream = http.ByteStream(menuFile.openRead());
      var fileLength = await menuFile.length();
      var multipartFile = http.MultipartFile(
        'menuFile',
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
}
