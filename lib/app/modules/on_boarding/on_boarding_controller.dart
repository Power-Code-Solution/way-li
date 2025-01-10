import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayli/app/modules/login/login_view.dart';

class OnBoardingController extends GetxController {
  //TODO: Implement OnBoardingController.
var selectPage = 0.obs; 
var controller = PageController().obs; 

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
List<Map<String, String>> pageArr = [
    {
      "title": "Find Food You Love",
      "subtitle":
          "Discover the best foods from over 1,000\nrestaurants and fast delivery to your\ndoorstep",
      "image": "assets/images/way-li_logo.png",
      // "image": "assets/images/on_boarding_1.png",
    },
    {
      "title": "Fast Delivery",
      "subtitle": "Fast food delivery to your home, office\n wherever you are",
      "image": "assets/images/way-li_logo.png",
      // "image": "assets/images/on_boarding_2.png",
    },
    {
      "title": "Live Tracking",
      "subtitle":
          "Real time tracking of your food on the app\nonce you placed the order",
      "image": "assets/images/way-li_logo.png",
      // "image": "assets/images/on_boarding_3.png",
    },
  ];
void updatePage(int index) {
    selectPage.value = index;
  }

 void goToNextPage() {
    if (selectPage.value >= pageArr.length - 1) {      Get.to(() => LoginView());
    } else {
      selectPage.value++;
      controller.value.animateToPage(
        selectPage.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

}
