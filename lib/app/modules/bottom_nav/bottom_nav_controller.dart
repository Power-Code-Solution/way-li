import 'package:get/get.dart';

class BottomNavController extends GetxController {
  //TODO: Implement BottomNavController.

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

}
