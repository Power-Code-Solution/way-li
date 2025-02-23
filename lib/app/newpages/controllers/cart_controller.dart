import 'package:get/get.dart';

class CartController extends GetxController {
  var isLoading = false.obs;
  var isSuccess = false.obs;

  Future<void> handleAddToCart() async {
    if (isLoading.value) return;

    isLoading.value = true;
    isSuccess.value = false;

    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;
    isSuccess.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isSuccess.value = false;
    });
  }
}
