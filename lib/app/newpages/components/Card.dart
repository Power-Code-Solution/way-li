import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../core/model/food_items.dart';
import '../../modules/cart/cart_controller_fixed2.dart';
import '../../modules/product_details/product_details_controller.dart';
import '../../modules/product_details/product_details_view.dart';
import 'package:wayli/app/newpages/components/colors.dart' show mainBlack, mainYellow;

class CardMain extends StatelessWidget {
  final FoodItem foodItem;
  final CartController cartController = Get.put(CartController());

  CardMain({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    String imageUrl = (foodItem.foodItemsImages != null &&
        foodItem.foodItemsImages!.isNotEmpty)
        ? foodItem.foodItemsImages![0].image
        : '';

    final size = MediaQuery.of(context).size;
    final containerWidth = size.width * 0.4;
    final containerHeight = containerWidth * 1.3;

    return GestureDetector(
      onTap: () {
        final controller = Get.find<ProductDetailsController>();
        controller.FIL = foodItem;
        Get.to(() => const ProductDetailsView(), arguments: {'FIL': foodItem});
      },
      child: Container(
        height: containerHeight,
        width: containerWidth,
        margin: EdgeInsets.all(size.width * 0.02),
        decoration: BoxDecoration(
          border: Border.all(color: mainYellow, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Image
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imageUrl.isNotEmpty ? imageUrl : "assets/images/food.png",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    "assets/images/food.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: MediaQuery(
                // 👇 Clamp text scale so system font won't overflow card
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 keeps button at bottom
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Name
                      Flexible(
                        child: AutoSizeText(
                          foodItem.name ?? 'N/A',
                          style: GoogleFonts.poppins(
                            fontSize: containerWidth * 0.12,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 16, // 👈 prevent overscaling
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Price
                      Flexible(
                        child: AutoSizeText(
                          "LE ${foodItem.price?.toString() ?? 'N/A'}",
                          style: GoogleFonts.poppins(
                            fontSize: containerWidth * 0.1,
                            fontWeight: FontWeight.w500,
                            color: mainBlack,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Button at bottom
                      Obx(
                            () => GestureDetector(
                          onTap: () => cartController.handleAddToCart(foodItem),
                          child: Container(
                            alignment: Alignment.center,
                            height: containerHeight * 0.13,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: cartController.cartItems.contains(foodItem)
                                  ? mainBlack
                                  : mainYellow,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: cartController.cartItems.contains(foodItem)
                                ? const Icon(Icons.check, color: Colors.white)
                                : AutoSizeText(
                              "Add to cart",
                              style: GoogleFonts.poppins(
                                fontSize: containerWidth * 0.09,
                                fontWeight: FontWeight.w500,
                                color: mainBlack,
                              ),
                              maxLines: 1,
                              minFontSize: 8,
                              maxFontSize: 12,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
