import 'package:get/get.dart';

class BottomNavController extends GetxController {
  //TODO: Implement BottomNavController.

  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
