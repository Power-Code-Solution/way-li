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

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;

      final encodedEmail = base64.encode(utf8.encode(email));
      final encodedPassword = base64.encode(utf8.encode(password));

      final response = await http.post(
        Uri.parse("$apiBaseAddress/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": encodedEmail,
          "password": encodedPassword,
        }),
      );

      if (response.statusCode == 200) {
        final parsedResponse = jsonDecode(response.body);

        if (parsedResponse["status"] == 1) {
          final token = parsedResponse["data"]["token"];
          final userData = parsedResponse["data"]["user"];

          await _saveToken(token);
          await _saveUserData(userData);
          userName.value = '${userData["firstName"]} ${userData["lastName"]}';
          isLoggedIn.value = true;
          userName.value = '${userData["firstName"]} ${userData["lastName"]}';
          userEmail.value = userData["email"] ?? '';
          print("User name after login: ${userName.value}");
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
    await _storage.delete(key: 'auth_token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
     Get.offAll(() => LoginView());
    isLoggedIn.value = false;
    userName.value = '';
    userEmail.value = '';
  }

  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userData["id"].toString());
    await prefs.setString('user_email', userData["email"] ?? '');
    await prefs.setString(
        'user_name', '${userData["firstName"]} ${userData["lastName"]}');
  }

  Future<void> checkLoginStatus() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null && token.isNotEmpty) {
        isLoggedIn.value = true;
        final prefs = await SharedPreferences.getInstance();
        userName.value = prefs.getString('user_name') ?? '';
        userEmail.value = prefs.getString('user_email') ?? '';
        print("User is logged in.");
      } else {
        isLoggedIn.value = false;
      }
    } catch (e) {
      print("Failed to read token from secure storage: $e");
      try {
        await _storage.deleteAll();
      } catch (cleanupError) {
      }
      isLoggedIn.value = false;
    }
  }


  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString('user_id') ?? '',
      'userEmail': prefs.getString('user_email') ?? '',
      'userName': prefs.getString('user_name') ?? '',
    };
  }
}
