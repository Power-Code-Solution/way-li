import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/newpages/Pages/ProjectDetails.dart';
import 'package:wayli/app/newpages/components/colors.dart'
    show mainBlack, mainYellow;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/newpages/Pages/ProjectDetails.dart';
import 'package:wayli/app/newpages/components/colors.dart' show mainBlack, mainYellow;
import 'package:get/get.dart';


import '../../core/model/food_items.dart';
import '../../modules/cart/cart_controller.dart';
import '../../modules/food_detail/food_detail_view.dart';
import '../../modules/product_details/product_details_view.dart';

class CardMain extends StatelessWidget {
  final FoodItem foodItem;
  final CartController cartController = Get.put(CartController());

  CardMain({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = foodItem.foodItemsImages.isNotEmpty
        ? foodItem.foodItemsImages[0].image
        : '';
    final size = MediaQuery.of(context).size;
    final containerWidth = size.width * 0.4;
    final containerHeight = containerWidth * 1.2;
    final imageWidth = containerWidth * 0.8;
    final imageHeight = imageWidth * 0.7;
    final buttonWidth = containerWidth * 0.7;
    final buttonHeight = containerHeight * 0.15;

    return Container(
      margin: EdgeInsets.all(size.width * 0.02),
      child: Column(
        children: [
          GestureDetector(
          onTap: () {
    Get.to(
    () => ProductDetailsView(),
    arguments: {'FIL': foodItem},
    );
    },
      child: Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          border: Border.all(
            color: mainYellow,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: containerHeight * 0.02),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl.isNotEmpty ? imageUrl : "assets/images/food.png",
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: mainYellow,
                      ),
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image.asset("assets/images/food.png", fit: BoxFit.cover);
                },
              ),
            ),
            Text(
              foodItem.name ?? 'N/A',
              style: GoogleFonts.poppins(
                fontSize: containerWidth * 0.1,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "LE " + (foodItem.price.toString() ?? 'N/A'),
              style: GoogleFonts.poppins(
                fontSize: containerWidth * 0.09,
                fontWeight: FontWeight.w500,
              ),
            ),
            Obx(() => GestureDetector(
              onTap: () => cartController.handleAddToCart(foodItem),
              child: Container(
                alignment: Alignment.center,
                width: buttonWidth,
                height: buttonHeight,
                decoration: BoxDecoration(
                  color: cartController.cartItems.contains(foodItem)
                      ? mainBlack
                      : mainYellow,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: cartController.cartItems.contains(foodItem)
                    ? Icon(Icons.check, color: Colors.white, size: buttonHeight * 0.5)
                    : Text(
                  "Add to cart",
                  style: GoogleFonts.poppins(
                    fontSize: buttonWidth * 0.12,
                    fontWeight: FontWeight.w500,
                    color: mainBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )),






            SizedBox(height: containerHeight * 0.02),
          ],
        ),
      ),
    )

    ],
      ),
    );
  }
}

