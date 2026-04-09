import 'package:get/get.dart';

class HelpController extends GetxController {
  // Add any reactive variables or methods needed for the Help page
  
  // Observable variables for FAQ expansion state
  final RxList<bool> faqExpandedState = <bool>[false, false, false, false, false, false].obs;
  
  // Toggle FAQ expansion state
  void toggleFaqExpansion(int index) {
    if (index >= 0 && index < faqExpandedState.length) {
      faqExpandedState[index] = !faqExpandedState[index];
    }
  }
  
  @override
  void onInit() {
    super.onInit();
    // Initialize any data or services needed for the Help page
  }
  
  @override
  void onClose() {
    // Clean up any resources when the controller is closed
    super.onClose();
  }
}