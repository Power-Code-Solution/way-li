import 'package:get/get.dart';

import '../../core/model/food_items.dart';

class CartController extends GetxController {
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var cartItems = <FoodItem>[].obs;
  var itemQuantities = <int, RxInt>{}.obs;
  var itemPrices = <int, RxDouble>{}.obs;
  var itemSuccessState = <int, RxBool>{}.obs;
  var totalPrice = 0.0.obs;

  // Handle Add/Remove item from the cart
  void handleAddToCart(FoodItem item) {
    if (cartItems.contains(item)) {
      cartItems.remove(item);
      itemQuantities.remove(item.id);
      itemPrices.remove(item.id);
    } else {
      cartItems.add(item);
      itemQuantities[item.id] = 1.obs;
      itemPrices[item.id] = (item.price * itemQuantities[item.id]!.value).obs;
    }
    updateTotalPrice();
  }

  void addItem(FoodItem item) {
    if (!cartItems.any((i) => i.id == item.id)) {
      cartItems.add(item);
    }

    if (!itemQuantities.containsKey(item.id)) {
      itemQuantities[item.id] = 1.obs;
    }

    if (!itemPrices.containsKey(item.id)) {
      itemPrices[item.id] = (item.price * itemQuantities[item.id]!.value).obs;
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
    final quantity = itemQuantities[itemId]!.value;
    final totalPrice = item.price * quantity;
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
}
