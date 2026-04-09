import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/modules/cart/cart_page.dart';
import 'package:wayli/app/modules/product_details/product_details_controller.dart';
import '../../core/config/constants.dart';
import '../../core/model/food_items.dart';
import '../../newpages/components/colors.dart';
import '../cart/cart_controller_fixed2.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    if (Get.arguments == null || !Get.arguments.containsKey('FIL')) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: mainYellow,
          title: const AutoSizeText("Details"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                "Error: Item information not found",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "Please go back and try again",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainYellow,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  "Go Back",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final FoodItem FIL = controller.FIL;
    String imageUrl = (FIL.foodItemsImages != null && FIL.foodItemsImages!.isNotEmpty)
        ? FIL.foodItemsImages![0].image ?? ''
        : '';
    final CartController cartController = Get.find<CartController>();
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final containerWidth = size.width * 0.85;
    final containerHeight = size.height * 0.35;
    final imageWidth = containerWidth * 0.7;
    final imageHeight = containerHeight * 0.55;
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
          title: const AutoSizeText("Item Details"),
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
              Center(
                child: Container(
                  height: containerHeight,
                  width: containerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: mainYellow),
                  ),
                  clipBehavior: Clip.antiAlias, // Ensures child respects borderRadius
                  child: Stack(
                    children: [
                      // Background image that fills container
                      Positioned.fill(
                        child: Image.network(
                          imageUrl ?? "assets/images/food.png",
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Favorite icon in top-right
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: controller.toggleLiked,
                          icon: Obx(() => Icon(
                            controller.liked.value ? Icons.favorite : Icons.favorite_border,
                            color: controller.liked.value ? Colors.red : Colors.black,
                            size: size.width * 0.06,
                          )),
                        ),
                      ),
                    ],
                  ),
                )
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          controller.FIL.name ?? "Unknown Product",
                          style: GoogleFonts.montserrat(
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.w500,
                          ),
                          maxFontSize: 14,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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
                  ),
                  SizedBox(width: size.width * 0.02), // spacing between text and price
                  AutoSizeText(
                    "LE ${(controller.FIL.price ?? 0).toStringAsFixed(2)}",
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
                            cartController.decreaseQuantity(FIL.id ?? 0);
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
                            cartController.increaseQuantity(FIL.id ?? 0);
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
                FIL.description ?? "No description available.",
                style: GoogleFonts.montserrat(
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF989898),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Center(
                child: SizedBox(
                  width: containerWidth,
                  height: size.height * 0.08,
                  child: Row(
                    children: [
                      Expanded(child: ElevatedButton(
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
                      )),
                      const Gap(8),
                      Expanded(child: ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed('/feedback', arguments: {'foodItem': controller.FIL});
                        },
                        icon: const Icon(Icons.rate_review, color: secondaryColor),
                        label: AutoSizeText(
                          "Give Feedback",
                          style: GoogleFonts.montserrat(
                            color: secondaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 8,
                          maxFontSize: 12,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ))
                    ],
                  )
                ),
              ),
              SizedBox(height: padding.bottom + size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  // Feedback functionality moved to a dedicated page

}
