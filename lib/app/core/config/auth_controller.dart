import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/modules/cart/cart_page.dart';
import 'package:wayli/app/modules/login/login_view.dart';

class AuthController extends GetxController {
  final _storage = const FlutterSecureStorage();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userId = ''.obs;
  var userPhone = ''.obs;
  var userRole = ''.obs;
  var userData = RxMap<String, dynamic>({});
  var pendingCheckoutAfterLogin = false.obs;

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;

      final encodedEmail = base64.encode(utf8.encode(email));
      final encodedPassword = base64.encode(utf8.encode(password));

      final loginUrl = Uri.parse("$apiBaseAddress/auth/login");
      final loginPayload = jsonEncode({
        "email": encodedEmail,
        "password": encodedPassword,
      });
      final response = await http.post(
        loginUrl,
        headers: {"Content-Type": "application/json"},
        body: loginPayload,
      );
      if (response.statusCode == 200) {
        final parsedResponse = jsonDecode(response.body);

        if (parsedResponse["status"] == 1) {
          final token = parsedResponse["data"]["token"];
          final userDataFromResponse = parsedResponse["data"]["user"];
          await _saveToken(token);
          await _saveUserData(userDataFromResponse);
          userData.value = Map<String, dynamic>.from(userDataFromResponse);
          userName.value = userDataFromResponse["fullname"] ?? '';
          userEmail.value = userDataFromResponse["email"] ?? '';
          userId.value = userDataFromResponse["id"]?.toString() ?? '';
          userPhone.value = userDataFromResponse["phone"] ?? '';
          userRole.value = userDataFromResponse["role"] ?? '';
          isLoggedIn.value = true;
          return true;
        } else {
          Get.snackbar("Login Failed", parsedResponse["message"],
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red);
          throw Exception(parsedResponse["message"]);
        }
      } else {
        Get.snackbar("Login Failed", "Unexpected server response.",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red);
        throw Exception('Login failed');
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    final prefs = await SharedPreferences.getInstance();
    final hasOnboarded = prefs.getBool('hasOnboarded') ?? false;
    await prefs.clear();
    await prefs.setBool('hasOnboarded', hasOnboarded);
    isLoggedIn.value = false;
    userName.value = '';
    userEmail.value = '';
    userId.value = '';
    userPhone.value = '';
    userRole.value = '';
    userData.clear();
    pendingCheckoutAfterLogin.value = false;
    Get.offAllNamed('/bottom-nav');
  }

  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userData["id"]?.toString() ?? '');
    await prefs.setString('user_email', userData["email"] ?? '');
    await prefs.setString('user_name', userData["fullname"] ?? '');
    await prefs.setString('user_phone', userData["phone"] ?? '');
    await prefs.setString('user_role', userData["role"] ?? '');
    await prefs.setString('user_data', jsonEncode(userData));
  }

  Future<void> checkLoginStatus() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null && token.isNotEmpty) {
        isLoggedIn.value = true;
        final prefs = await SharedPreferences.getInstance();
        userName.value = prefs.getString('user_name') ?? '';
        userEmail.value = prefs.getString('user_email') ?? '';
        userId.value = prefs.getString('user_id') ?? '';
        userPhone.value = prefs.getString('user_phone') ?? '';
        userRole.value = prefs.getString('user_role') ?? '';
        String? userDataJson = prefs.getString('user_data');
        if (userDataJson != null && userDataJson.isNotEmpty) {
          try {
            userData.value =
                Map<String, dynamic>.from(jsonDecode(userDataJson));
          } catch (e) {}
        }
      } else {
        isLoggedIn.value = false;
      }
    } catch (e) {
      try {
        await _storage.deleteAll();
      } catch (cleanupError) {}
      isLoggedIn.value = false;
    }
  }

  Future<bool> ensureAuthenticated({
    bool redirectToCheckout = false,
    String? message,
  }) async {
    await checkLoginStatus();
    if (isLoggedIn.value) {
      return true;
    }

    if (redirectToCheckout) {
      pendingCheckoutAfterLogin.value = true;
    }

    final prompt = message ?? "Please sign in to continue with this action.";
    Get.snackbar(
      "Login Required",
      prompt,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
    Get.to(
      () => const LoginView(),
      arguments: {
        "redirectToCheckout": redirectToCheckout,
        "loginReason": prompt,
      },
    );
    return false;
  }

  void completePostLoginFlow() {
    final shouldReturnToCheckout = pendingCheckoutAfterLogin.value;
    pendingCheckoutAfterLogin.value = false;

    Get.offAllNamed('/bottom-nav');

    if (shouldReturnToCheckout) {
      Future.delayed(const Duration(milliseconds: 150), () {
        Get.to(
          () => const CartPage(),
          arguments: {"openCheckout": true},
        );
      });
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> saveBiometricCredentials(String email, String password) async {
    await _storage.write(key: 'biometric_email', value: email);
    await _storage.write(key: 'biometric_password', value: password);
  }

  Future<Map<String, String?>> getBiometricCredentials() async {
    final email = await _storage.read(key: 'biometric_email');
    final password = await _storage.read(key: 'biometric_password');
    return {
      'email': email,
      'password': password,
    };
  }

  Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString('user_id') ?? '',
      'userEmail': prefs.getString('user_email') ?? '',
      'userName': prefs.getString('user_name') ?? '',
      'userPhone': prefs.getString('user_phone') ?? '',
      'userRole': prefs.getString('user_role') ?? '',
    };
  }

  Map<String, dynamic> getCompleteUserData() {
    return Map<String, dynamic>.from(userData);
  }

  Future<bool> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final token = await getToken();
      if (token == null) {
        isLoggedIn.value = false;
        return false;
      }
      final response = await http.get(
        Uri.parse("$apiBaseAddress/secure/admin/user/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final parsedResponse = jsonDecode(response.body);

        if (parsedResponse["status"] == 1) {
          final profileData = parsedResponse["data"];
          userData.value = Map<String, dynamic>.from(profileData);
          userName.value = profileData["fullname"] ?? '';
          userEmail.value = profileData["email"] ?? '';
          userId.value = profileData["id"]?.toString() ?? '';
          userPhone.value = profileData["phone"] ?? '';
          await _saveUserData(profileData);
          return true;
        } else {
          Get.snackbar(
              "Error", parsedResponse["message"] ?? "Failed to fetch profile",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
          return false;
        }
      } else {
        Get.snackbar("Error", "Failed to fetch profile",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    required String fullname,
    required String email,
    required String phone,
    String? address,
  }) async {
    try {
      isLoading.value = true;
      final token = await getToken();
      if (token == null) {
        await ensureAuthenticated(
          message: "Please sign in to update your profile.",
        );
        return false;
      }
      final requestBody = {
        "fullname": fullname,
        "email": email,
        "phone": phone,
      };
      if (address != null && address.isNotEmpty) {
        requestBody["address"] = address;
      }
      final url = Uri.parse("$apiBaseAddress/secure/admin/user/update");
      final body = jsonEncode(requestBody);
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
          final updatedUserData = parsedResponse["data"];
          userData.value = Map<String, dynamic>.from(updatedUserData);
          userName.value = updatedUserData["fullname"] ?? '';
          userEmail.value = updatedUserData["email"] ?? '';
          userPhone.value = updatedUserData["phone"] ?? '';
          await _saveUserData(updatedUserData);
          Get.snackbar("Success", "Profile updated successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green);
          return true;
        } else {
          Get.snackbar(
              "Error", parsedResponse["message"] ?? "Failed to update profile",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
          return false;
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          Get.snackbar(
              "Error", errorResponse["message"] ?? "Failed to update profile",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        } catch (e) {
          Get.snackbar("Error", "Failed to update profile",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        }
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      final token = await getToken();
      if (token == null) {
        await ensureAuthenticated(
          message: "Please sign in to change your password.",
        );
        return false;
      }
      final url = "$apiBaseAddress/secure/admin/user/change/password";
      final uri = Uri.parse(url);
      final payload = {
        "oldPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };
      final body = jsonEncode(payload);
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );
      if (response.statusCode == 200) {
        final parsedResponse = jsonDecode(response.body);
        if (parsedResponse["status"] == 1) {
          Get.offAllNamed('login');
          Get.snackbar("Success",
              parsedResponse["data"] ?? "Password changed successfully",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.green);
          return true;
        } else {
          Get.snackbar(
              "Error", parsedResponse["message"] ?? "Failed to change password",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red);
          return false;
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          Get.snackbar(
              "Error", errorResponse["message"] ?? "Failed to change password",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red);
        } catch (e) {
          Get.snackbar("Error", "Failed to change password",
              snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        }
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An Error occurred while changing password",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      isLoading.value = true;
      final token = await getToken();
      if (token == null) {
        await ensureAuthenticated(
          message: "Please sign in to manage your account.",
        );
        return false;
      }
      final response = await http.post(
        Uri.parse("$apiBaseAddress/secure/admin/user/delete"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final parsedResponse = jsonDecode(response.body);

        if (parsedResponse["status"] == 1) {
          await _storage.delete(key: 'auth_token');
          final prefs = await SharedPreferences.getInstance();
          final hasOnboarded = prefs.getBool('hasOnboarded') ?? false;
          await prefs.clear();
          await prefs.setBool('hasOnboarded', hasOnboarded);
          isLoggedIn.value = false;
          userName.value = '';
          userEmail.value = '';
          userId.value = '';
          userPhone.value = '';
          userRole.value = '';
          userData.clear();
          pendingCheckoutAfterLogin.value = false;
          Get.snackbar("Success",
              parsedResponse["message"] ?? "User Deleted Successfully",
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.green);
          Get.offAllNamed('/bottom-nav');
          return true;
        } else {
          Get.snackbar(
              "Error", parsedResponse["message"] ?? "Failed to delete account",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red);
          return false;
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          Get.snackbar(
              "Error", errorResponse["message"] ?? "Failed to delete account",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red);
        } catch (e) {
          Get.snackbar("Error", "Failed to delete account",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red);
        }
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while deleting the account",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
