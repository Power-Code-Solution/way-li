import 'package:get/get.dart';
import 'cart_controller_fixed2.dart';

class CartBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(CartController());
    }
}