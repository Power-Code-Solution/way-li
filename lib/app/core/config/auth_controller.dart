import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayli/app/core/config/constants.dart';
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
      print('[DEBUG_LOG] POST ${loginUrl.toString()}');
      print('[DEBUG_LOG] Headers: {Content-Type: application/json}');
      print('[DEBUG_LOG] Payload: ' + loginPayload);
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

          // Log the complete user data received after login
          print("Login response data: ${parsedResponse["data"]}");
          print("User data received after login: $userDataFromResponse");

          await _saveToken(token);
          await _saveUserData(userDataFromResponse);

          // Store all user data in the userData map
          userData.value = Map<String, dynamic>.from(userDataFromResponse);

          // Set individual properties
          userName.value = userDataFromResponse["fullname"] ?? '';
          userEmail.value = userDataFromResponse["email"] ?? '';
          userId.value = userDataFromResponse["id"]?.toString() ?? '';
          userPhone.value = userDataFromResponse["phone"] ?? '';
          userRole.value = userDataFromResponse["role"] ?? '';

          isLoggedIn.value = true;

          print("User data after login:");
          print("User ID: ${userId.value}");
          print("User name: ${userName.value}");
          print("User email: ${userEmail.value}");
          print("User phone: ${userPhone.value}");
          print("User role: ${userRole.value}");
          return true;
        } else {
          Get.snackbar("Login Failed", parsedResponse["message"]);
          throw Exception(parsedResponse["message"]);
        }
      } else {
        Get.snackbar("Login Failed", "Unexpected server response.");
        throw Exception('Login failed');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print('Login error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    // Clear secure storage
    await _storage.delete(key: 'auth_token');

    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Reset all user data variables
    isLoggedIn.value = false;
    userName.value = '';
    userEmail.value = '';
    userId.value = '';
    userPhone.value = '';
    userRole.value = '';
    userData.clear();

    print("User logged out, all data cleared");

    // Navigate to login screen
    Get.offAll(() => LoginView());
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

    // Save the complete user data as a JSON string
    await prefs.setString('user_data', jsonEncode(userData));

    print("User data saved to SharedPreferences");
  }

  Future<void> checkLoginStatus() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null && token.isNotEmpty) {
        isLoggedIn.value = true;
        final prefs = await SharedPreferences.getInstance();

        // Load basic user information
        userName.value = prefs.getString('user_name') ?? '';
        userEmail.value = prefs.getString('user_email') ?? '';
        userId.value = prefs.getString('user_id') ?? '';
        userPhone.value = prefs.getString('user_phone') ?? '';
        userRole.value = prefs.getString('user_role') ?? '';

        // Load complete user data if available
        String? userDataJson = prefs.getString('user_data');
        if (userDataJson != null && userDataJson.isNotEmpty) {
          try {
            userData.value = Map<String, dynamic>.from(jsonDecode(userDataJson));
            print("Loaded complete user data from SharedPreferences");
          } catch (e) {
            print("Error parsing user data JSON: $e");
          }
        }

        print("User is logged in with the following information:");
        print("User ID: ${userId.value}");
        print("User name: ${userName.value}");
        print("User email: ${userEmail.value}");
        print("User phone: ${userPhone.value}");
        print("User role: ${userRole.value}");
      } else {
        isLoggedIn.value = false;
      }
    } catch (e) {
      print("Failed to read token from secure storage: $e");
      try {
        await _storage.deleteAll();
      } catch (cleanupError) {
        print("Error during cleanup: $cleanupError");
      }
      isLoggedIn.value = false;
    }
  }


  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Save credentials for biometric login
  Future<void> saveBiometricCredentials(String email, String password) async {
    await _storage.write(key: 'biometric_email', value: email);
    await _storage.write(key: 'biometric_password', value: password);
    print('Credentials saved for biometric login');
  }

  // Get credentials for biometric login
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

  // Get the complete user data as a Map
  Map<String, dynamic> getCompleteUserData() {
    return userData.value;
  }

  // Fetch user profile data
  Future<bool> fetchUserProfile() async {
    try {
      isLoading.value = true;

      // Get the auth token
      final token = await getToken();
      if (token == null) {
        Get.snackbar("Error", "You are not logged in");
        return false;
      }

      // Make the API call
      final response = await http.get(
        Uri.parse("$apiBaseAddress/secure/admin/user/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Fetch profile response: ${response.body}");

      if (response.statusCode == 200) {
        final parsedResponse = jsonDecode(response.body);

        if (parsedResponse["status"] == 1) {
          final profileData = parsedResponse["data"];

          // Update the user data in memory
          userData.value = Map<String, dynamic>.from(profileData);
          userName.value = profileData["fullname"] ?? '';
          userEmail.value = profileData["email"] ?? '';
          userId.value = profileData["id"]?.toString() ?? '';
          userPhone.value = profileData["phone"] ?? '';

          // Save the updated user data to SharedPreferences
          await _saveUserData(profileData);

          print("User profile fetched successfully");
          print("User data: $profileData");
          return true;
        } else {
          Get.snackbar("Error", parsedResponse["message"] ?? "Failed to fetch profile");
          return false;
        }
      } else {
        Get.snackbar("Error", "Failed to fetch profile");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print('Fetch profile error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    required String fullname,
    required String email,
    required String phone,
    String? address,
  }) async {
    try {
      isLoading.value = true;

      // Get the auth token
      final token = await getToken();
      if (token == null) {
        Get.snackbar("Error", "You are not logged in");
        return false;
      }

      // Prepare the request body
      final requestBody = {
        "fullname": fullname,
        "email": email,
        "phone": phone,
      };

      // Add address if provided
      if (address != null && address.isNotEmpty) {
        requestBody["address"] = address;
      }

      final url = Uri.parse("$apiBaseAddress/secure/admin/user/update");
      final body = jsonEncode(requestBody);
      final masked = token.length > 12 ? token.substring(0,6) + '...' + token.substring(token.length-6) : '***';
      print('[DEBUG_LOG] POST ' + url.toString());
      print('[DEBUG_LOG] Headers: {Content-Type: application/json, Authorization: Bearer ' + masked + '}');
      print('[DEBUG_LOG] Payload: ' + body);
      // Make the API call
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Update profile response: ${response.body}");

      if (response.statusCode == 200) {
        final parsedResponse = jsonDecode(response.body);

        if (parsedResponse["status"] == 1) {
          final updatedUserData = parsedResponse["data"];

          // Update the user data in memory
          userData.value = Map<String, dynamic>.from(updatedUserData);
          userName.value = updatedUserData["fullname"] ?? '';
          userEmail.value = updatedUserData["email"] ?? '';
          userPhone.value = updatedUserData["phone"] ?? '';

          // Save the updated user data to SharedPreferences
          await _saveUserData(updatedUserData);

          Get.snackbar("Success", "Profile updated successfully");
          return true;
        } else {
          Get.snackbar("Error", parsedResponse["message"] ?? "Failed to update profile");
          return false;
        }
      } else {
        // Handle error response
        try {
          final errorResponse = jsonDecode(response.body);
          Get.snackbar("Error", errorResponse["message"] ?? "Failed to update profile");
        } catch (e) {
          Get.snackbar("Error", "Failed to update profile");
        }
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print('Update profile error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;

      // Get the auth token
      final token = await getToken();
      if (token == null) {
        Get.snackbar("Error", "You are not logged in");
        return false;
      }
      final url = "$apiBaseAddress/secure/admin/user/change/password";
      final uri = Uri.parse(url);
      final payload = {
        "oldPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };
      final masked = token.length > 12 ? token.substring(0,6) + '...' + token.substring(token.length-6) : '***';
      final body = jsonEncode(payload);
      print('[DEBUG_LOG] POST ' + uri.toString());
      print('[DEBUG_LOG] Headers: {Content-Type: application/json, Authorization: Bearer ' + masked + '}');
      print('[DEBUG_LOG] Payload: ' + body);
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
          Get.snackbar("Success", parsedResponse["data"] ?? "Password changed successfully");
          return true;
        } else {
          Get.snackbar("Error", parsedResponse["message"] ?? "Failed to change password");
          return false;
        }
      } else {
        // Handle error response
        try {
          final errorResponse = jsonDecode(response.body);
          Get.snackbar("Error", errorResponse["message"] ?? "Failed to change password");
        } catch (e) {
          Get.snackbar("Error", "Failed to change password");
        }
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print('Change password error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete account
  Future<bool> deleteAccount() async {
    try {
      isLoading.value = true;
      final token = await getToken();
      if (token == null) {
        Get.snackbar("Error", "You are not logged in");
        return false;
      }
      final response = await http.post(
        Uri.parse("$apiBaseAddress/secure/admin/user/delete"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Delete account response: ${response.body}");

      if (response.statusCode == 200) {
        final parsedResponse = jsonDecode(response.body);

        if (parsedResponse["status"] == 1) {
          // Clear all user data
          await _storage.delete(key: 'auth_token');
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();

          // Reset all user data variables
          isLoggedIn.value = false;
          userName.value = '';
          userEmail.value = '';
          userId.value = '';
          userPhone.value = '';
          userRole.value = '';
          userData.clear();

          // Show success message
          Get.snackbar("Success", parsedResponse["message"] ?? "User Deleted Successfully");

          // Navigate to login screen
          Get.offAllNamed('/login');
          return true;
        } else {
          Get.snackbar("Error", parsedResponse["message"] ?? "Failed to delete account");
          return false;
        }
      } else {
        // Handle error response
        try {
          final errorResponse = jsonDecode(response.body);
          Get.snackbar("Error", errorResponse["message"] ?? "Failed to delete account");
        } catch (e) {
          Get.snackbar("Error", "Failed to delete account");
        }
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print('Delete account error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
