import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/modules/product_details/product_details_controller.dart';

import '../../core/model/food_items.dart';
import '../../newpages/Pages/Cart.dart';
import '../../newpages/components/colors.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    FoodItem FIL = Get.arguments['FIL'];
    String imageUrl = FIL.foodItemsImages.isNotEmpty ? FIL.foodItemsImages[0].image : '';

    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final containerWidth = size.width * 0.85;
    final containerHeight = size.height * 0.35;
    final imageWidth = containerWidth * 0.7;
    final imageHeight = containerHeight * 0.55;
    final ProductDetailsController controller = Get.put(ProductDetailsController());
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
          title: const Text("Product Details"),
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
                      Text(
                        FIL.name,
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: size.height * 0.005),
                      Text(
                        "In Stock",
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w400,
                          color: const Color(0XFF13B7419),
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
                  Text(
                      "\LE ${FIL.price.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
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
                  Text(
                    "Quantity",
                    style: GoogleFonts.poppins(
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
                          onPressed: controller.decreaseCount,
                          icon: Icon(
                            Icons.remove,
                            size: size.width * 0.05,
                          ),
                          color: Colors.black,
                        ),
                        SizedBox(width: size.width * 0.02),
                        Obx(() => Text(
                          '${controller.itemCount.value}',
                          style: TextStyle(fontSize: size.width * 0.06),
                        )),
                        SizedBox(width: size.width * 0.02),
                        IconButton(
                          onPressed: controller.increaseCount,
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
              Text(
                "Details",
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                FIL.description ?? "No description available",
                style: GoogleFonts.poppins(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Add to Cart",
                      style: GoogleFonts.poppins(
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
