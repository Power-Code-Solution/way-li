import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/config/auth_controller.dart';
import '../../core/config/constants.dart';
import '../../core/model/food_items.dart';


class FeedbackController extends GetxController {
  // Food item that feedback is for
  late FoodItem foodItem;
  
  // Feedback form fields
  var rating = 0.0.obs;
  var comment = ''.obs;
  var email = ''.obs;
  var name = ''.obs;
  
  // Submission state
  var isSubmitting = false.obs;
  var submitSuccess = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments.containsKey('foodItem')) {
      foodItem = Get.arguments['foodItem'];
    }
  }

  Future<bool> submitFeedback() async {
    try {
      isSubmitting.value = true;
      submitSuccess.value = false;
      errorMessage.value = '';
      
      if (comment.value.isEmpty) {
        errorMessage.value = 'Please enter a comment';
        return false;
      }
      
      final authController = Get.find<AuthController>();
      final token = await authController.getToken();
      
      if (token == null) {
        errorMessage.value = 'You are not logged in';
        return false;
      }
      
      final requestBody = {
        "foodItemId": foodItem.id,
        "rating": rating.value,
        "comment": comment.value,
        "email": email.value,
        "name": name.value
      };
      
      final url = Uri.parse("$apiBaseAddress/feedback/submit");
      final body = jsonEncode(requestBody);
      final masked = token.length > 12 ? token.substring(0,6) + '...' + token.substring(token.length-6) : '***';
      print('[DEBUG_LOG] POST ' + url.toString());
      print('[DEBUG_LOG] Headers: {Content-Type: application/json, Authorization: Bearer ' + masked + '}');
      print('[DEBUG_LOG] Payload: ' + body);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );
      
      if (response.statusCode == 200) {
        final parsedResponse = jsonDecode(response.body);
        if (parsedResponse["status"] == 1) {
          submitSuccess.value = true;
          Get.offAllNamed('/bottom-nav');
          Get.snackbar(
            "Success",
            parsedResponse["message"] ?? "Thank you for your feedback!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primaryColor,
            colorText: secondaryColor,
            duration: const Duration(seconds: 3),
          );
          
          return true;
        } else {
          errorMessage.value = parsedResponse["message"] ?? "Failed to submit feedback";
          showErrorSnackbar(errorMessage.value);
          return false;
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          errorMessage.value = errorResponse["message"] ?? "Failed to submit feedback";
        } catch (e) {
          errorMessage.value = "Failed to submit feedback";
        }

        showErrorSnackbar(errorMessage.value);
        return false;
      }
    } catch (e) {
      print('Feedback submission error: $e');
      errorMessage.value = e.toString();

      showErrorSnackbar("An unexpected error occurred");
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: primaryColor,
      colorText: secondaryColor,
      duration: const Duration(seconds: 3),
    );
  }
}