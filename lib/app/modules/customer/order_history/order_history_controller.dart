import 'package:get/get.dart';
import 'package:wayli/app/core/model/saved_cart_item.dart';
import 'package:wayli/app/modules/cart/cart_controller_fixed2.dart';

class OrderHistoryController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final savedOrders = <SavedOrder>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedOrders();
  }

  Future<void> loadSavedOrders() async {
    try {
      isLoading.value = true;
      final orders = await cartController.loadSavedOrders();
      orders.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      savedOrders.value = orders;
    } catch (e) {
      print("[DEBUG_LOG] Error loading saved orders in OrderHistoryController: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    await loadSavedOrders();
  }
  String getFormattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
  int getRemainingDays(DateTime expiresAt) {
    final now = DateTime.now();
    final difference = expiresAt.difference(now);
    return difference.inDays;
  }
}
