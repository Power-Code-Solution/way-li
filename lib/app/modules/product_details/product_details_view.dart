import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/modules/cart/cart_page.dart';
import 'package:wayli/app/modules/product_details/product_details_controller.dart';

import '../../core/model/food_items.dart';
import '../../newpages/Pages/Cart.dart';
import '../../newpages/components/colors.dart';
import '../cart/cart_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    FoodItem FIL = Get.arguments['FIL'];

    String imageUrl =
        FIL.foodItemsImages.isNotEmpty ? FIL.foodItemsImages[0].image : '';
    final CartController cartController = Get.find<CartController>();

    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final containerWidth = size.width * 0.85;
    final containerHeight = size.height * 0.35;
    final imageWidth = containerWidth * 0.7;
    final imageHeight = containerHeight * 0.55;
    final ProductDetailsController controller =
        Get.put(ProductDetailsController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.08),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: mainYellow,
          title: const AutoSizeText("Product Details"),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              // Product Image Container
              Center(
                child: Container(
                  height: containerHeight,
                  width: containerWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: mainYellow),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: controller.toggleLiked,
                            icon: Obx(() => Icon(
                                  controller.liked.value
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: controller.liked.value
                                      ? Colors.red
                                      : Colors.black,
                                  size: size.width * 0.06,
                                )),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl ?? "assets/images/food.png",
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Product Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        FIL.name,
                        style: GoogleFonts.montserrat(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: size.height * 0.005),
                      AutoSizeText(
                        "In Stock",
                        style: GoogleFonts.montserrat(
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w400,
                          color: const Color(0Xff13b7419),
                        ),
                      ),
                      SizedBox(height: size.height * 0.005),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: mainYellow,
                            size: size.width * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AutoSizeText(
                    "LE ${FIL.price.toStringAsFixed(2)}",
                    style: GoogleFonts.montserrat(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              // Quantity Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    "Quantity",
                    style: GoogleFonts.montserrat(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: mainYellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (kDebugMode) {
                              print(
                                  'Decreasing quantity of item: ${FIL.name}, current quantity: ${cartController.itemQuantities[FIL.id]?.value ?? 1}');
                            }
                            cartController.decreaseQuantity(FIL.id);
                          },
                          icon: const Icon(Icons.remove),
                          color: mainBlack,
                        ),
                        SizedBox(width: size.width * 0.02),
                        Obx(() => AutoSizeText(
                              '${cartController.itemQuantities[FIL.id]?.value ?? 1}',
                              style: GoogleFonts.montserrat(
                                  fontSize: size.width * 0.06),
                            )),
                        SizedBox(width: size.width * 0.02),
                        IconButton(
                          onPressed: () {
                            if (kDebugMode) {
                              print(
                                  'Increasing quantity of item: ${FIL.name}, current quantity: ${cartController.itemQuantities[FIL.id]?.value ?? 1}');
                            }
                            cartController.increaseQuantity(FIL.id);
                          },
                          icon: Icon(
                            Icons.add,
                            size: size.width * 0.05,
                          ),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              // Product Details
              AutoSizeText(
                "Details",
                style: GoogleFonts.montserrat(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              AutoSizeText(
                FIL.description,
                style: GoogleFonts.montserrat(
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF989898),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Add to Cart Button
              Center(
                child: SizedBox(
                  width: containerWidth,
                  height: size.height * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      cartController.addItem(FIL);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CartPage()));
                      Get.snackbar('Added to Cart',
                          '${FIL.name} has been added to your cart.');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: AutoSizeText(
                      "Add to Cart",
                      style: GoogleFonts.montserrat(
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: padding.bottom + size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
