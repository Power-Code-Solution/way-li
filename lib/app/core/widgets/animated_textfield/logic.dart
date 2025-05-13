import 'package:get/get.dart';

class AnimatedTextfieldLogic extends GetxController {
  var isTyping = false.obs; // Reactive variable

  void onTextChanged(String value) {
    isTyping.value = value.isNotEmpty; // Update typing state
  }
}