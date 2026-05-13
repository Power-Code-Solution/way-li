import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingController extends GetxController {
  var selectPage = 0.obs;
  var controller = PageController().obs;

  @override
  void onInit() {
    super.onInit();
    // Guard: if user has already completed onboarding, skip this screen
    _redirectIfCompleted();
  }

  Future<void> _redirectIfCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final hasOnboarded = prefs.getBool('hasOnboarded') ?? false;
    if (hasOnboarded) {
      Get.offAllNamed('/bottom-nav');
    }
  }

  List<Map<String, String>> pageArr = [
    {
      "title": "Find Food You Love",
      "subtitle":
          "Discover the best foods  and fast delivery to your\ndoorstep",
      "image": "assets/images/c2.png",
      // "image": "assets/images/on_boarding_1.png",
    },
    {
      "title": "Fast Delivery",
      "subtitle": "Fast food delivery to your home, office\n wherever you are",
      "image": "assets/images/f4.png",
      // "image": "assets/images/on_boarding_2.png",
    },
    {
      "title": "Live Tracking",
      "subtitle":
          "Real time tracking of your food on the app\nonce you placed the order",
      "image": "assets/images/f1.png",
      // "image": "assets/images/on_boarding_3.png",
    },
  ];
  void updatePage(int index) {
    selectPage.value = index;
  }

  void goToNextPage() {
    if (selectPage.value >= pageArr.length - 1) {
      completeOnboarding();
    } else {
      selectPage.value++;
      controller.value.animateToPage(
        selectPage.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasOnboarded', true);
    Get.offAllNamed('/bottom-nav');
  }
}
