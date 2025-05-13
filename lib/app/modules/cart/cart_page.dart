import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/modules/food_category/food_category_view.dart';
import 'package:wayli/app/newpages/Pages/HomePage.dart';
import '../../core/config/constants.dart';
import '../../newpages/Pages/Payment.dart';
import '../../newpages/components/colors.dart';
import './cart_controller.dart';

class CartPage extends GetView<CartController> {
  static const String routeName = '/cart';

  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Get.offAll(Homepage()), // Navigate to HomePage
        ),
        backgroundColor: Colors.yellow, // Replace with your mainYellow
        title: const Text("Cart"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            Expanded(
              child: Obx(() {
                if (cartController.cartItems.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/way-li_logo.png',
                            height: 200,
                            width: 200,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Cart Empty',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 10),
                          AutoSizeText(
                            "You haven't added anything to cart",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FoodCategoryView()
                                      // const MyOrderView()
                                      ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              shadowColor: Colors.transparent,
                            ),
                            child: AutoSizeText(
                              'Explore',
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return Obx(() => Container(
                          margin: EdgeInsets.only(bottom: size.height * 0.01),
                          decoration: BoxDecoration(
                            color: mainYellow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: size.width * 0.15,
                              height: size.width * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(item.foodItemsImages.isNotEmpty ? item.foodItemsImages[0].image: ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: AutoSizeText(item.name, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
                            subtitle: Obx(() {
                              final price =
                                  cartController.itemPrices[item.id]?.value ??
                                      0.0;
                              return AutoSizeText("Le ${price * 85 / 100 }", style: GoogleFonts.montserrat(),);
                            }),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      cartController.decreaseQuantity(item.id),
                                  icon: const Icon(Icons.remove),
                                  color: mainBlack,
                                ),
                                AutoSizeText(
                                  '${cartController.itemQuantities[item.id]?.value}',
                                  style: GoogleFonts.montserrat(fontSize: size.width * 0.06),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      cartController.increaseQuantity(item.id),
                                  icon: const Icon(Icons.add),
                                  color: mainBlack,
                                ),
                                IconButton(
                                  onPressed: () =>
                                      cartController.removeItem(item.id),
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                );
              }),
            ),
            Obx(() {
              return Column(
                children: [
                  if (controller.getTotalPrice() > 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPriceRow(
                              "Price before tax",
                              "Le ${cartController.getTotalPriceWithoutTax().toStringAsFixed(2)}",
                              size),
                          SizedBox(height: size.height * 0.01),
                          _buildPriceRow("Discount", "Le 0.00", size),
                          _buildPriceRow("Tax (15%)", "Le ${cartController.getTotalTax().toStringAsFixed(2)}", size),
                          Divider(
                            color: Colors.grey,
                            height: 10,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                          ),
                          _buildPriceRow(
                              "Total",
                              "Le ${cartController.getTotalPrice().toStringAsFixed(2)}",
                              size,
                              isTotal: true),
                          SizedBox(height: size.height * 0.02),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              // Customize the color
                              minimumSize:
                                  Size(size.width * 0.9, size.height * 0.06),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PaymentPage()),
                              );
                            },
                            child: Text(
                              "Checkout",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: size.width * 0.04,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          // Padding at the bottom
                        ],
                      ),
                    )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, Size size,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: isTotal ? size.width * 0.05 : size.width * 0.04,
              color: isTotal ? secondaryColor : mainBlack,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w500,
              fontSize: isTotal ? size.width * 0.05 : size.width * 0.04,
              color: isTotal ? secondaryColor : mainBlack,
            ),
          ),
        ],
      ),
    );
  }
}
