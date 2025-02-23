import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/newpages/Pages/ProjectDetails.dart';
import 'package:wayli/app/newpages/components/colors.dart'
    show mainBlack, mainYellow;
//
// class CardMain extends StatefulWidget {
//   const CardMain({super.key});
//
//   @override
//   State<CardMain> createState() => _CardMainState();
// }
//
// class _CardMainState extends State<CardMain> {
//   bool _isLoading = false;
//   bool _isSuccess = false;
//
//   Future<void> _handleAddToCart(BuildContext context) async {
//     if (_isLoading) return;
//
//     setState(() {
//       _isLoading = true;
//       _isSuccess = false;
//     });
//
//     // Simulate network request
//     await Future.delayed(const Duration(seconds: 2));
//
//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//         _isSuccess = true;
//       });
//
//       // Show snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "Added to cart successfully",
//             style: GoogleFonts.poppins(),
//           ),
//           backgroundColor: mainBlack,
//           duration: const Duration(seconds: 2),
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.only(
//             bottom: MediaQuery.of(context).size.height - 100,
//             left: 10,
//             right: 10,
//           ),
//         ),
//       );
//
//       // Reset success state after 2 seconds
//       Future.delayed(const Duration(seconds: 2), () {
//         if (mounted) {
//           setState(() {
//             _isSuccess = false;
//           });
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Get screen dimensions
//     final size = MediaQuery.of(context).size;
//
//     // Calculate responsive dimensions
//     final containerWidth = size.width * 0.4;
//     final containerHeight = containerWidth * 1.2;
//     final imageWidth = containerWidth * 0.8;
//     final imageHeight = imageWidth * 0.7;
//     final buttonWidth = containerWidth * 0.7;
//     final buttonHeight = containerHeight * 0.15;
//
//     return Container(
//       margin: EdgeInsets.all(size.width * 0.02),
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => ProductDetails()));
//             },
//             child: Container(
//               height: containerHeight,
//               width: containerWidth,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: mainYellow,
//                   width: 2,
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   SizedBox(height: containerHeight * 0.02),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.asset(
//                       "assets/burger.png",
//                       width: imageWidth,
//                       height: imageHeight,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Text(
//                     "Cheese Burger",
//                     style: GoogleFonts.poppins(
//                       fontSize: containerWidth * 0.1,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Text(
//                     "Le 389",
//                     style: GoogleFonts.poppins(
//                       fontSize: containerWidth * 0.09,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => _handleAddToCart(context),
//                     child: Container(
//                       alignment: Alignment.center,
//                       width: buttonWidth,
//                       height: buttonHeight,
//                       decoration: BoxDecoration(
//                         color: _isSuccess ? mainBlack : mainYellow,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: _isLoading
//                           ? SizedBox(
//                               width: buttonHeight * 0.5,
//                               height: buttonHeight * 0.5,
//                               child: CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   _isSuccess ? Colors.white : mainBlack,
//                                 ),
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : _isSuccess
//                               ? Icon(
//                                   Icons.check,
//                                   color: Colors.white,
//                                   size: buttonHeight * 0.5,
//                                 )
//                               : Text(
//                                   "Add to cart",
//                                   style: GoogleFonts.poppins(
//                                     fontSize: buttonWidth * 0.12,
//                                     fontWeight: FontWeight.w500,
//                                     color: mainBlack,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                     ),
//                   ),
//                   SizedBox(height: containerHeight * 0.02),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/newpages/Pages/ProjectDetails.dart';
import 'package:wayli/app/newpages/components/colors.dart' show mainBlack, mainYellow;
import 'package:get/get.dart';
import 'package:wayli/app/newpages/controllers/cart_controller.dart';

import '../../core/model/food_items.dart';

class CardMain extends StatelessWidget {
  final FoodItem foodItem; // Required FoodItem
  final CartController cartController = Get.put(CartController());

  CardMain({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = foodItem.foodItemsImages.isNotEmpty
        ? foodItem.foodItemsImages[0].image
        : '';

    final size = MediaQuery.of(context).size;

    // Calculate responsive dimensions
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductDetails()));
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
                    onTap: () => cartController.handleAddToCart(),
                    child: Container(
                      alignment: Alignment.center,
                      width: buttonWidth,
                      height: buttonHeight,
                      decoration: BoxDecoration(
                        color: cartController.isSuccess.value ? mainBlack : mainYellow,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: cartController.isLoading.value
                          ? SizedBox(
                        width: buttonHeight * 0.5,
                        height: buttonHeight * 0.5,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            cartController.isSuccess.value ? Colors.white : mainBlack,
                          ),
                          strokeWidth: 2,
                        ),
                      )
                          : cartController.isSuccess.value
                          ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: buttonHeight * 0.5,
                      )
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
          ),
        ],
      ),
    );
  }
}

