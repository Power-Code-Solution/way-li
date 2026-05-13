import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/model/delivery_fee.dart';
import '../../core/model/food_items.dart';
import '../../core/model/saved_cart_item.dart';
import '../../core/model/monime_payment_response.dart';
import '../../core/config/constants.dart';
import '../../core/config/auth_controller.dart';

class CartController extends GetxController {
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var cartItems = <FoodItem>[].obs;
  var itemQuantities = <int, RxInt>{}.obs;
  var itemPrices = <int, RxDouble>{}.obs;
  var itemSuccessState = <int, RxBool>{}.obs;
  var totalPrice = 0.0.obs;
  var deliveryFees = <DeliveryFee>[].obs;
  var selectedDeliveryFee = Rxn<DeliveryFee>();
  var isDeliveryFeesLoading = false.obs;
  var deliveryFeesError = ''.obs;
  var orderSubmitSuccess = false.obs;
  var orderSubmitMessage = ''.obs;
  var orderResponse = RxMap<String, dynamic>({});
  var monimePaymentResult = Rxn<MonimePaymentResult>();
  var isMonimeLoading = false.obs;
  var monimeError = ''.obs;

  // Key for storing saved orders in SharedPreferences
  static const String savedOrdersKey = 'saved_orders';

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryFees();
  }

  double get currentDeliveryFee => selectedDeliveryFee.value?.fee ?? 0.0;
  String get currentDeliveryAddress => selectedDeliveryFee.value?.address ?? '';
  bool get hasDeliveryFeeSelection => selectedDeliveryFee.value != null;

  String _formatAmount(double amount) {
    return amount == amount.truncateToDouble()
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2);
  }

  String _normalizePhoneNumber(String phoneNumber) {
    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) {
      return digits;
    }
    return '232${digits.substring(digits.length - 8)}';
  }

  String _extractErrorMessage(
    Map<String, dynamic> response, {
    required String fallback,
  }) {
    final message = response['message']?.toString();
    if (message != null && message.trim().isNotEmpty) {
      return message;
    }

    final messages = response['messages'];
    if (messages is List && messages.isNotEmpty) {
      return messages.first.toString();
    }

    return fallback;
  }

  void _logMobileApiResponse({
    required String name,
    required String method,
    required Uri url,
    required http.Response response,
  }) {
    if (!kDebugMode) {
      return;
    }

    debugPrint("[MOBILE_API][$name] $method $url");
    debugPrint("[MOBILE_API][$name] Status: ${response.statusCode}");
    debugPrint(
      "[MOBILE_API][$name] Response:\n${_formatResponseForDebug(response.body)}",
    );
  }

  void _logMobileApiError(String name, Object error, StackTrace stackTrace) {
    if (!kDebugMode) {
      return;
    }

    debugPrint("[MOBILE_API][$name] Error: $error");
    debugPrint("[MOBILE_API][$name] StackTrace: $stackTrace");
  }

  String _formatResponseForDebug(String body) {
    if (body.trim().isEmpty) {
      return "<empty-response>";
    }

    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(jsonDecode(body));
    } catch (_) {
      return body;
    }
  }

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
        itemPrices[item.id!] =
            (item.price! * itemQuantities[item.id!]!.value).obs;
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
        itemPrices[item.id!] =
            ((item.price ?? 0.0) * itemQuantities[item.id!]!.value).obs;
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

  double getTotalWithDelivery(bool isDelivery) {
    if (!isDelivery) {
      return totalPrice.value;
    }
    return totalPrice.value + currentDeliveryFee;
  }

  int get totalCartItems {
    int total = 0;
    for (final quantity in itemQuantities.values) {
      total += quantity.value;
    }
    return total;
  }

  FoodItem getItemById(int itemId) {
    return cartItems.firstWhere((item) => item.id == itemId);
  }

  Future<void> fetchDeliveryFees({bool force = false}) async {
    if (deliveryFees.isNotEmpty && !force) {
      return;
    }
    try {
      isDeliveryFeesLoading.value = true;
      deliveryFeesError.value = '';
      final url = Uri.parse(publicDeliveryFeesBaseAddress);
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });
      if (response.statusCode == 200) {
        final parsedResponse = jsonDecode(response.body);
        if (parsedResponse["status"] == 1) {
          final list = (parsedResponse["data"] as List? ?? [])
              .map((e) => DeliveryFee.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          list.sort((a, b) => a.address.compareTo(b.address));
          deliveryFees.assignAll(list);
          return;
        }
        deliveryFeesError.value =
            parsedResponse["message"] ?? "Failed to load delivery fees";
        return;
      }
      deliveryFeesError.value =
          "Failed to load delivery fees (${response.statusCode})";
    } catch (e) {
      deliveryFeesError.value = "Failed to load delivery fees";
    } finally {
      isDeliveryFeesLoading.value = false;
    }
  }

  void selectDeliveryFee(DeliveryFee fee) {
    selectedDeliveryFee.value = fee;
  }

  void clearDeliveryFeeSelection() {
    selectedDeliveryFee.value = null;
  }

  Future<bool> submitOrder({
    required String location,
    required String deliveryAddress,
    required String deliveryPhone,
    String? deliveryNotes,
    double deliveryFee = 0.0,
    String? monimePaymentId,
  }) async {
    try {
      isLoading.value = true;
      orderSubmitSuccess.value = false;
      final authController = Get.find<AuthController>();
      final token = await authController.getToken();

      if (token == null) {
        orderSubmitMessage.value = "You are not logged in";
        await authController.ensureAuthenticated(
          redirectToCheckout: true,
          message: "Please sign in to place your order securely.",
        );
        isLoading.value = false;
        return false;
      }
      List<Map<String, dynamic>> items = [];
      final normalizedDeliveryPhone = _normalizePhoneNumber(deliveryPhone);
      for (var item in cartItems) {
        if (item.id != null) {
          items.add({
            "foodItemId": item.id,
            "quantity": itemQuantities[item.id]?.value ?? 1
          });
        }
      }
      if (items.isEmpty) {
        orderSubmitMessage.value = "Your cart is empty";
        return false;
      }
      final requestBody = {
        "location": location,
        "deliveryAddress": deliveryAddress,
        "deliveryPhone": normalizedDeliveryPhone.isNotEmpty
            ? normalizedDeliveryPhone
            : deliveryPhone.trim(),
        "deliveryNotes": deliveryNotes ?? "",
        if (monimePaymentId != null && monimePaymentId.trim().isNotEmpty)
          "monimePaymentId": monimePaymentId.trim(),
        "items": items
      };
      final submitUrl = Uri.parse("$apiBaseAddress/secure/admin/order/submit");
      final requestJson = jsonEncode(requestBody);
      final response = await http.post(
        submitUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: requestJson,
      );
      _logMobileApiResponse(
        name: "ORDER_CREATE",
        method: "POST",
        url: submitUrl,
        response: response,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsedResponse = jsonDecode(response.body);
        if (parsedResponse["status"] == 1) {
          orderResponse.value = Map<String, dynamic>.from(parsedResponse);
          orderSubmitSuccess.value = true;
          orderSubmitMessage.value =
              parsedResponse["message"] ?? "Order submitted successfully";
          await saveCartItemsToLocalStorage(
            location: location,
            deliveryAddress: deliveryAddress,
            deliveryPhone: normalizedDeliveryPhone.isNotEmpty
                ? normalizedDeliveryPhone
                : deliveryPhone.trim(),
            deliveryNotes: deliveryNotes,
            deliveryFee: deliveryFee,
          );
          return true;
        } else {
          isLoading.value = false;
          orderSubmitMessage.value =
              parsedResponse["message"] ?? "Failed to submit order";
          return false;
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          isLoading.value = false;
          if (response.statusCode == 500 &&
              errorResponse["message"] != null &&
              errorResponse["message"].toString().contains("Requested value")) {
            isLoading.value = false;
            orderSubmitMessage.value =
                "Location not available. Please select a different location.";
          } else {
            isLoading.value = false;
            orderSubmitMessage.value =
                errorResponse["message"] ?? "Failed to submit order";
          }
        } catch (e) {
          isLoading.value = false;
          orderSubmitMessage.value = "Failed to submit order";
        }
        return false;
      }
    } catch (e, stackTrace) {
      _logMobileApiError("ORDER_CREATE", e, stackTrace);
      orderSubmitMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearCart() {
    cartItems.clear();
    itemQuantities.clear();
    itemPrices.clear();
    totalPrice.value = 0.0;
    selectedDeliveryFee.value = null;
    monimePaymentResult.value = null;
    monimeError.value = '';
  }

  Future<MonimePaymentResult?> initiateMonimePayment({
    required double amount,
    required String customerName,
    required String phoneNumber,
    int? orderId,
  }) async {
    try {
      isMonimeLoading.value = true;
      monimeError.value = '';
      final authController = Get.find<AuthController>();
      final token = await authController.getToken();

      if (token == null) {
        monimeError.value = "You are not logged in";
        await authController.ensureAuthenticated(
          redirectToCheckout: true,
          message: "Please sign in before generating a payment code.",
        );
        return null;
      }

      final trimmedCustomerName = customerName.trim();
      if (trimmedCustomerName.isEmpty) {
        monimeError.value = "Customer name is required";
        return null;
      }

      final normalizedPhoneNumber = _normalizePhoneNumber(phoneNumber);
      if (normalizedPhoneNumber.length != 11) {
        monimeError.value = "Please enter a valid Sierra Leone phone number";
        return null;
      }

      final url = Uri.parse(
        "$apiBaseAddress/secure/admin/payment/monime/initiate",
      ).replace(
        queryParameters: {
          "amount": _formatAmount(amount),
          "customerName": trimmedCustomerName,
          "phoneNumber": normalizedPhoneNumber,
          if (orderId != null) "orderId": "$orderId",
        },
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      _logMobileApiResponse(
        name: "MONIME_INITIATE",
        method: "POST",
        url: url,
        response: response,
      );

      final parsedResponse = response.body.isNotEmpty
          ? Map<String, dynamic>.from(jsonDecode(response.body))
          : <String, dynamic>{};

      if (response.statusCode == 200 || response.statusCode == 201) {
        final monimeResponse = MonimePaymentResponse.fromJson(parsedResponse);
        if (monimeResponse.success && monimeResponse.result != null) {
          monimePaymentResult.value = monimeResponse.result;
          return monimeResponse.result;
        } else {
          monimeError.value = monimeResponse.messages.isNotEmpty
              ? monimeResponse.messages.first
              : (monimeResponse.message ?? "Failed to initiate payment");
        }
      } else {
        monimeError.value = _extractErrorMessage(
          parsedResponse,
          fallback: "Server error: ${response.statusCode}",
        );
      }
    } catch (e, stackTrace) {
      _logMobileApiError("MONIME_INITIATE", e, stackTrace);
      monimeError.value = "Error: $e";
    } finally {
      isMonimeLoading.value = false;
    }
    return null;
  }

  Future<MonimePaymentResult?> checkMonimePaymentStatus(String monimeId) async {
    try {
      final authController = Get.find<AuthController>();
      final token = await authController.getToken();

      if (token == null) return null;

      final url = Uri.parse(
          "$apiBaseAddress/secure/admin/payment/monime/status/$monimeId");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      _logMobileApiResponse(
        name: "MONIME_STATUS",
        method: "GET",
        url: url,
        response: response,
      );

      if (response.statusCode == 200) {
        final parsedResponse =
            Map<String, dynamic>.from(jsonDecode(response.body));
        final monimeResponse = MonimePaymentResponse.fromJson(parsedResponse);
        if (monimeResponse.success && monimeResponse.result != null) {
          monimePaymentResult.value = monimeResponse.result;
          return monimeResponse.result;
        }
      } else if (response.body.isNotEmpty) {
        final parsedResponse =
            Map<String, dynamic>.from(jsonDecode(response.body));
        monimeError.value = _extractErrorMessage(
          parsedResponse,
          fallback: "Unable to refresh payment status",
        );
      }
    } catch (e, stackTrace) {
      _logMobileApiError("MONIME_STATUS", e, stackTrace);
      print("Error checking payment status: $e");
    }
    return null;
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
    double deliveryFee = 0.0,
  }) async {
    try {
      print("[DEBUG_LOG] Saving cart items to local storage");
      final now = DateTime.now();
      final expiresAt = now.add(Duration(days: 7));
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
      final savedOrder = SavedOrder(
        id: _generateUniqueId(), // Generate a unique ID
        items: savedItems,
        totalAmount: totalPrice.value + deliveryFee,
        location: location,
        deliveryAddress: deliveryAddress,
        deliveryPhone: deliveryPhone,
        deliveryNotes: deliveryNotes,
        savedAt: now,
        expiresAt: expiresAt,
      );
      final prefs = await SharedPreferences.getInstance();
      final String? savedOrdersJson = prefs.getString(savedOrdersKey);
      List<SavedOrder> savedOrders = [];
      if (savedOrdersJson != null && savedOrdersJson.isNotEmpty) {
        savedOrders = SavedOrder.decode(savedOrdersJson);
      }
      savedOrders.removeWhere((order) => order.isExpired());
      savedOrders.add(savedOrder);
      await prefs.setString(savedOrdersKey, SavedOrder.encode(savedOrders));
    } catch (e) {}
  }

  Future<List<SavedOrder>> loadSavedOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedOrdersJson = prefs.getString(savedOrdersKey);
      if (savedOrdersJson == null || savedOrdersJson.isEmpty) {
        return [];
      }
      List<SavedOrder> savedOrders = SavedOrder.decode(savedOrdersJson);
      savedOrders.removeWhere((order) => order.isExpired());
      await prefs.setString(savedOrdersKey, SavedOrder.encode(savedOrders));
      return savedOrders;
    } catch (e) {
      return [];
    }
  }
}
