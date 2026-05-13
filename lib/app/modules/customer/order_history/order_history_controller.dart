import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wayli/app/core/config/auth_controller.dart';
import 'package:wayli/app/core/config/constants.dart';

class OrderItemLine {
  final String foodName;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final int? foodItemId;
  OrderItemLine(
      {required this.foodName,
      required this.quantity,
      required this.unitPrice,
      required this.lineTotal,
      this.foodItemId});
  factory OrderItemLine.fromJson(Map<String, dynamic> json) => OrderItemLine(
        foodName: json['foodName'] ?? '',
        quantity: json['quantity'] ?? 0,
        unitPrice: (json['unitPrice'] ?? 0).toDouble(),
        lineTotal: (json['lineTotal'] ?? 0).toDouble(),
        // Prefer foodItemId, but keep fkFoodItemId fallback for older payloads
        foodItemId: json['foodItemId'] ?? json['fkFoodItemId'],
      );
}

class OrderHistoryItem {
  final int orderItemId;
  final int orderId;
  final DateTime orderDate;
  final String status;
  final String location;
  final String deliveryAddress;
  final String deliveryPhone;
  final double deliveryFee;
  final String itemStatus;
  final List<OrderItemLine> orderItems;
  OrderHistoryItem({
    required this.orderItemId,
    required this.orderId,
    required this.orderDate,
    required this.status,
    required this.location,
    required this.deliveryAddress,
    required this.deliveryPhone,
    required this.deliveryFee,
    required this.itemStatus,
    required this.orderItems,
  });
  factory OrderHistoryItem.fromJson(Map<String, dynamic> json) =>
      OrderHistoryItem(
        orderItemId: json['orderItemId'] ?? 0,
        orderId: json['orderId'] ?? 0,
        orderDate: DateTime.tryParse(json['orderDate'] ?? '') ?? DateTime.now(),
        status: json['status'] ?? '',
        location: json['location'] ?? '',
        deliveryAddress: json['deliveryAddress'] ?? '',
        deliveryPhone: json['deliveryPhone'] ?? '',
        deliveryFee:
            (json['deliveryFee'] ?? json['deliveryAmount'] ?? 0).toDouble(),
        itemStatus: json['itemStatus'] ?? '',
        orderItems: (json['orderItems'] as List? ?? [])
            .map((e) => OrderItemLine.fromJson(e))
            .toList(),
      );
}

class OrderHistorySummary {
  final int userId;
  final int totalItems;
  final double totalAmount;
  final List<OrderHistoryItem> items;
  OrderHistorySummary(
      {required this.userId,
      required this.totalItems,
      required this.totalAmount,
      required this.items});
  factory OrderHistorySummary.fromJson(Map<String, dynamic> json) =>
      OrderHistorySummary(
        userId: json['userId'] ?? 0,
        totalItems: json['totalItems'] ?? 0,
        totalAmount: (json['totalAmount'] ?? 0).toDouble(),
        items: (json['items'] as List? ?? [])
            .map((e) => OrderHistoryItem.fromJson(e))
            .toList(),
      );
}

class OrderHistoryController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final isLoading = false.obs;
  final items = <OrderHistoryItem>[].obs;
  final totalItems = 0.obs;
  final totalAmount = 0.0.obs;
  final isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderHistory();
  }

  @override
  void onReady() {
    // Ensure latest data is shown whenever the view becomes ready/visible
    // This complements onInit() (which may run only once depending on binding lifecycle)
    refreshOrders();
    super.onReady();
  }

  Future<void> fetchOrderHistory() async {
    try {
      isLoading.value = true;
      final token = await authController.getToken();
      if (token == null) {
        items.clear();
        totalItems.value = 0;
        totalAmount.value = 0;
        return;
      }
      final url = Uri.parse("$apiBaseAddress/secure/admin/order/my-items");
      final masked = token.length > 12
          ? token.substring(0, 6) + '...' + token.substring(token.length - 6)
          : '***';
      print('[DEBUG_LOG] GET ' + url.toString());
      print(
          '[DEBUG_LOG] Headers: {Content-Type: application/json, Authorization: Bearer ' +
              masked +
              '}');
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (resp.statusCode == 200) {
        final json = jsonDecode(resp.body);
        if (json['status'] == 1) {
          final data = json['data'];
          final summary =
              OrderHistorySummary.fromJson(Map<String, dynamic>.from(data));
          items.assignAll(summary.items);
          totalItems.value = summary.totalItems;
          totalAmount.value = summary.totalAmount;
        } else {
          Get.snackbar('Error', json['message'] ?? 'Failed to fetch history',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('Error', 'Server error: ${resp.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('[DEBUG_LOG] Error fetching order history: $e');
      Get.snackbar('Error', "Failed to fetch order history",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    await fetchOrderHistory();
  }

  Future<bool> cancelOrder(int orderId) async {
    try {
      isProcessing.value = true;
      final token = await authController.getToken();
      if (token == null) {
        Get.snackbar('Error', 'You are not logged in',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
      final url =
          Uri.parse("$apiBaseAddress/secure/admin/order/cancel?id=$orderId");
      final masked = token.length > 12
          ? token.substring(0, 6) + '...' + token.substring(token.length - 6)
          : '***';
      print('[DEBUG_LOG] POST ' + url.toString());
      print(
          '[DEBUG_LOG] Headers: {Content-Type: application/json, Authorization: Bearer ' +
              masked +
              '}');
      print('[DEBUG_LOG] Payload: <no body>');
      final resp = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (resp.statusCode == 200) {
        final json = jsonDecode(resp.body);
        if (json['status'] == 1) {
          Get.snackbar('Success', 'Order #$orderId cancelled',
              snackPosition: SnackPosition.BOTTOM);
          await fetchOrderHistory();
          return true;
        } else {
          Get.snackbar('Error', json['message'] ?? 'Failed to cancel order',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('Error', 'Server error: ${resp.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', "Failed to cancel order",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  String getFormattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
