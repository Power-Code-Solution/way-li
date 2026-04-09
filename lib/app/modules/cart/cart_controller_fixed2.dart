import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/model/delivery_fee.dart';
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
  var deliveryFees = <DeliveryFee>[].obs;
  var selectedDeliveryFee = Rxn<DeliveryFee>();
  var isDeliveryFeesLoading = false.obs;
  var deliveryFeesError = ''.obs;
  var orderSubmitSuccess = false.obs;
  var orderSubmitMessage = ''.obs;
  var orderResponse = RxMap<String, dynamic>({});

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
      final authController = Get.find<AuthController>();
      final token = await authController.getToken();
      final url = Uri.parse("$apiBaseAddress/secure/admin/delivery-fees/all");
      final headers = <String, String>{
        "Content-Type": "application/json",
      };
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
      final response = await http.get(url, headers: headers);
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
  }) async {
    try {
      isLoading.value = true;
      orderSubmitSuccess.value = false;
      final authController = Get.find<AuthController>();
      final token = await authController.getToken();

      if (token == null) {
        orderSubmitMessage.value = "You are not logged in";
        Get.to(() => LoginView());
        isLoading.value = false;
        return false;
      }
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
        orderSubmitMessage.value = "Your cart is empty";
        return false;
      }
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
      final response = await http.post(
        submitUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: requestJson,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsedResponse = jsonDecode(response.body);
        if (parsedResponse["status"] == 1) {
          orderResponse.value = Map<String, dynamic>.from(parsedResponse);
          orderSubmitSuccess.value = true;
          orderSubmitMessage.value = parsedResponse["message"] ?? "Order submitted successfully";
          await saveCartItemsToLocalStorage(
            location: location,
            deliveryAddress: deliveryAddress,
            deliveryPhone: deliveryPhone,
            deliveryNotes: deliveryNotes,
            deliveryFee: deliveryFee,
          );
          return true;
        } else {
          isLoading.value = false;
          orderSubmitMessage.value = parsedResponse["message"] ?? "Failed to submit order";
          return false;
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body);
          isLoading.value = false;
          if (response.statusCode == 500 && errorResponse["message"] != null &&
              errorResponse["message"].toString().contains("Requested value")) {
            isLoading.value = false;
            orderSubmitMessage.value = "Location not available. Please select a different location.";
          } else {
            isLoading.value = false;
            orderSubmitMessage.value = errorResponse["message"] ?? "Failed to submit order";
          }
        } catch (e) {
          isLoading.value = false;
          orderSubmitMessage.value = "Failed to submit order";
        }
        return false;
      }
    } catch (e) {
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
    } catch (e) {
    }
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
