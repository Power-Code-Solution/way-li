import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/model/food_items.dart';
import '../../core/model/saved_cart_item.dart';
import '../../core/config/constants.dart';
import '../../core/config/auth_controller.dart';
import '../login/login_view.dart';

class CartController extends GetxController {
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var cartItems = <FoodItem>[].obs;
  var itemQuantities = <int, RxInt>{}.obs;
  var itemPrices = <int, RxDouble>{}.obs;
  var itemSuccessState = <int, RxBool>{}.obs;
  var totalPrice = 0.0.obs;
  var orderSubmitSuccess = false.obs;
  var orderSubmitMessage = ''.obs;
  var orderResponse = RxMap<String, dynamic>({});

  // Key for storing saved orders in SharedPreferences
  static const String savedOrdersKey = 'saved_orders';

  // Generate a unique ID based on timestamp and random number
  String _generateUniqueId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(10000);
    return '$timestamp-$randomNum';
  }

  // Handle Add/Remove item from the cart
  void handleAddToCart(FoodItem item) {
    if (cartItems.contains(item)) {
      cartItems.remove(item);
      itemQuantities.remove(item.id);
      itemPrices.remove(item.id);
    } else {
      cartItems.add(item);
      if (item.id != null && item.price != null) {
        itemQuantities[item.id!] = 1.obs;
        itemPrices[item.id!] = (item.price! * itemQuantities[item.id!]!.value).obs;
      }
    }
    updateTotalPrice();
  }

  void addItem(FoodItem item) {
    if (!cartItems.any((i) => i.id == item.id)) {
      cartItems.add(item);
    }

    if (item.id != null && !itemQuantities.containsKey(item.id)) {
      itemQuantities[item.id!] = 1.obs;
    }

    if (!itemPrices.containsKey(item.id)) {
      if (item.id != null && item.price != null) {
        itemPrices[item.id!] = ((item.price ?? 0.0) * itemQuantities[item.id!]!.value).obs;
      }
    }

    updateTotalPrice();
  }

  void increaseQuantity(int itemId) {
    if (!itemQuantities.containsKey(itemId)) {
      itemQuantities[itemId] = 1.obs;
    }
    itemQuantities[itemId]!.value++;
    updateItemPrice(itemId);
    updateTotalPrice();
  }

  void decreaseQuantity(int itemId) {
    if (itemQuantities.containsKey(itemId) &&
        itemQuantities[itemId]!.value > 1) {
      itemQuantities[itemId]!.value--;
      updateItemPrice(itemId);
    }
    updateTotalPrice();
  }

  void updateItemPrice(int itemId) {
    final item = cartItems.firstWhere((item) => item.id == itemId);
    // Ensure quantity is initialized to avoid null assertion crashes
    if (!itemQuantities.containsKey(itemId)) {
      itemQuantities[itemId] = 1.obs;
    }
    final quantity = itemQuantities[itemId]!.value;
    final totalPrice = (item.price ?? 0.0) * quantity;
    itemPrices[itemId] = totalPrice.obs;
    updateTotalPrice();
  }

  void updateTotalPrice() {
    double newTotalPrice = 0.0;
    for (var item in cartItems) {
      newTotalPrice += itemPrices[item.id]?.value ?? 0.0;
    }
    totalPrice.value = newTotalPrice;
  }

  void removeItem(int itemId) {
    cartItems.removeWhere((item) => item.id == itemId);
    itemQuantities.remove(itemId);
    itemPrices.remove(itemId);
    updateTotalPrice();
  }

  double getTotalPrice() {
    return totalPrice.value;
  }

  double getTotalPriceWithoutTax() {
    return totalPrice.value * 85 / 100;
  }

  double getTotalTax() {
    return totalPrice.value * 15 / 100;
  }

  FoodItem getItemById(int itemId) {
    return cartItems.firstWhere((item) => item.id == itemId);
  }

  Future<bool> submitOrder({
    required String location,
    required String deliveryAddress,
    required String deliveryPhone,
    String? deliveryNotes,
  }) async {
    try {
      print("[DEBUG_LOG] Starting order submission process");
      isLoading.value = true;
      orderSubmitSuccess.value = false;
      print("[DEBUG_LOG] Getting auth token");
      final authController = Get.find<AuthController>();
      final token = await authController.getToken();

      if (token == null) {
        print("[DEBUG_LOG] Auth token is null, user not logged in");
        orderSubmitMessage.value = "You are not logged in";
        Get.to(() => LoginView());
        isLoading.value = false;
        return false;
      }

      // Prepare order items
      print("[DEBUG_LOG] Preparing order items");
      List<Map<String, dynamic>> items = [];
      for (var item in cartItems) {
        if (item.id != null) {
          items.add({
            "foodItemId": item.id,
            "quantity": itemQuantities[item.id]?.value ?? 1
          });
        }
      }
      if (items.isEmpty) {
        print("[DEBUG_LOG] Cart is empty, cannot submit order");
        orderSubmitMessage.value = "Your cart is empty";
        return false;
      }

      // Prepare request body
      final requestBody = {
        "location": location,
        "deliveryAddress": deliveryAddress,
        "deliveryPhone": deliveryPhone,
        "deliveryNotes": deliveryNotes ?? "",
        "items": items
      };
      final submitUrl = Uri.parse("$apiBaseAddress/secure/admin/order/submit");
      final maskedToken = token.length > 12 ? token.substring(0, 6) + '...' + token.substring(token.length - 6) : '***';
      final requestJson = jsonEncode(requestBody);
      print("[DEBUG_LOG] POST ${submitUrl.toString()}");
      print("[DEBUG_LOG] Headers: {Content-Type: application/json, Authorization: Bearer $maskedToken}");
      print("[DEBUG_LOG] Payload: $requestJson");
      final response = await http.post(
        submitUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: requestJson,
      );

      print("[DEBUG_LOG] Order submission response status code: ${response.statusCode}");
      print("[DEBUG_LOG] Order submission response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("[DEBUG_LOG] Response status code is ${response.statusCode}, parsing response");
        final parsedResponse = jsonDecode(response.body);

        if (parsedResponse["status"] == 1) {
          print("[DEBUG_LOG] Order submission successful, status=1");
          // Store response data
          orderResponse.value = Map<String, dynamic>.from(parsedResponse);
          orderSubmitSuccess.value = true;
          orderSubmitMessage.value = parsedResponse["message"] ?? "Order submitted successfully";
          print("[DEBUG_LOG] Order submit success set to true, message: ${orderSubmitMessage.value}");

          // Save cart items to local storage for 7 days
          await saveCartItemsToLocalStorage(
            location: location,
            deliveryAddress: deliveryAddress,
            deliveryPhone: deliveryPhone,
            deliveryNotes: deliveryNotes,
          );
          print("[DEBUG_LOG] Returning true to indicate successful submission");
          return true;
        } else {
          isLoading.value = false;
          print("[DEBUG_LOG] Order submission failed, status!=1, message: ${parsedResponse["message"]}");
          orderSubmitMessage.value = parsedResponse["message"] ?? "Failed to submit order";
          return false;
        }
      } else {
        print("[DEBUG_LOG] Response status code is not 200/201: ${response.statusCode}");
        try {
          final errorResponse = jsonDecode(response.body);
          isLoading.value = false;
          // Handle specific error for location not found
          if (response.statusCode == 500 && errorResponse["message"] != null &&
              errorResponse["message"].toString().contains("Requested value")) {
            print("[DEBUG_LOG] Location not found error detected");
            isLoading.value = false;
            orderSubmitMessage.value = "Location not available. Please select a different location.";
          } else {
            isLoading.value = false;
            orderSubmitMessage.value = errorResponse["message"] ?? "Failed to submit order";
          }
          print("[DEBUG_LOG] Error message from response: ${orderSubmitMessage.value}");
        } catch (e) {
          isLoading.value = false;
          print("[DEBUG_LOG] Failed to parse error response: $e");
          orderSubmitMessage.value = "Failed to submit order";
        }
        return false;
      }
    } catch (e) {
      print('[DEBUG_LOG] Order submission error: $e');
      orderSubmitMessage.value = e.toString();
      return false;
    } finally {
      print("[DEBUG_LOG] Order submission process completed, isLoading set to false");
      isLoading.value = false;
    }
  }

  void clearCart() {
    cartItems.clear();
    itemQuantities.clear();
    itemPrices.clear();
    totalPrice.value = 0.0;
  }

  void removeSubmittedItems(List<Map<String, dynamic>> submittedItems) {
    for (var item in submittedItems) {
      if (item["foodItemId"] != null) {
        removeItem(item["foodItemId"]);
      }
    }
    updateTotalPrice();
  }

  // Save the current cart items to local storage
  Future<void> saveCartItemsToLocalStorage({
    required String location,
    required String deliveryAddress,
    required String deliveryPhone,
    String? deliveryNotes,
  }) async {
    try {
      print("[DEBUG_LOG] Saving cart items to local storage");

      // Create a list of SavedCartItem objects
      final now = DateTime.now();
      final expiresAt = now.add(Duration(days: 7)); // Items expire after 7 days

      List<SavedCartItem> savedItems = [];

      for (var item in cartItems) {
        if (item.id != null) {
          final quantity = itemQuantities[item.id]?.value ?? 1;
          final totalPrice = itemPrices[item.id]?.value ?? 0.0;

          savedItems.add(SavedCartItem(
            foodItem: item,
            quantity: quantity,
            totalPrice: totalPrice,
            savedAt: now,
            expiresAt: expiresAt,
          ));
        }
      }

      if (savedItems.isEmpty) {
        print("[DEBUG_LOG] No items to save");
        return;
      }

      // Create a SavedOrder object
      final savedOrder = SavedOrder(
        id: _generateUniqueId(), // Generate a unique ID
        items: savedItems,
        totalAmount: totalPrice.value,
        location: location,
        deliveryAddress: deliveryAddress,
        deliveryPhone: deliveryPhone,
        deliveryNotes: deliveryNotes,
        savedAt: now,
        expiresAt: expiresAt,
      );

      // Get existing saved orders from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? savedOrdersJson = prefs.getString(savedOrdersKey);

      List<SavedOrder> savedOrders = [];
      if (savedOrdersJson != null && savedOrdersJson.isNotEmpty) {
        savedOrders = SavedOrder.decode(savedOrdersJson);
      }

      // Remove expired orders
      savedOrders.removeWhere((order) => order.isExpired());

      // Add the new order
      savedOrders.add(savedOrder);

      // Save the updated list back to SharedPreferences
      await prefs.setString(savedOrdersKey, SavedOrder.encode(savedOrders));

      print("[DEBUG_LOG] Cart items saved to local storage successfully");
    } catch (e) {
      print("[DEBUG_LOG] Error saving cart items to local storage: $e");
    }
  }

  // Load saved orders from local storage
  Future<List<SavedOrder>> loadSavedOrders() async {
    try {
      print("[DEBUG_LOG] Loading saved orders from local storage");

      final prefs = await SharedPreferences.getInstance();
      final String? savedOrdersJson = prefs.getString(savedOrdersKey);

      if (savedOrdersJson == null || savedOrdersJson.isEmpty) {
        print("[DEBUG_LOG] No saved orders found");
        return [];
      }

      List<SavedOrder> savedOrders = SavedOrder.decode(savedOrdersJson);

      // Remove expired orders
      savedOrders.removeWhere((order) => order.isExpired());

      // Save the updated list back to SharedPreferences (to remove expired orders)
      await prefs.setString(savedOrdersKey, SavedOrder.encode(savedOrders));

      print("[DEBUG_LOG] Loaded ${savedOrders.length} saved orders");
      return savedOrders;
    } catch (e) {
      print("[DEBUG_LOG] Error loading saved orders: $e");
      return [];
    }
  }
}
