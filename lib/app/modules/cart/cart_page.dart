import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/modules/food_category/food_category_view.dart';
import 'package:wayli/app/newpages/Pages/HomePage.dart';
import '../../core/config/constants.dart';
import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import '../../newpages/components/colors.dart';
import './cart_controller.dart';

class CartPage extends GetView<CartController> {
  static const String routeName = '/cart';

  const CartPage({super.key});

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
                            'assets/images/way-li-logo.png',
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
                                  image: NetworkImage(
                                      (item.foodItemsImages != null && item.foodItemsImages!.isNotEmpty)
                                          ? (item.foodItemsImages![0].image ?? '')
                                          : ''),

                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: AutoSizeText(
                              item.name ?? 'Unknown Item',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Obx(() {
                              final price =
                                  cartController.itemPrices[item.id]?.value ??
                                      0.0;
                              return AutoSizeText(
                                "Le ${price * 85 / 100}",
                                style: GoogleFonts.montserrat(),
                              );
                            }),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      cartController.decreaseQuantity(item.id ?? 0),
                                  icon: const Icon(Icons.remove),
                                  color: mainBlack,
                                ),
                                AutoSizeText(
                                  '${cartController.itemQuantities[item.id]?.value}',
                                  style: GoogleFonts.montserrat(
                                      fontSize: size.width * 0.06),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      cartController.increaseQuantity(item.id ?? 0),
                                  icon: const Icon(Icons.add),
                                  color: mainBlack,
                                ),
                                IconButton(
                                  onPressed: () =>
                                      cartController.removeItem(item.id ?? 0),
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
                          _buildPriceRow(
                              "Tax (15%)",
                              "Le ${cartController.getTotalTax().toStringAsFixed(2)}",
                              size),
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
                              minimumSize:
                                  Size(size.width * 0.9, size.height * 0.06),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => const CheckoutModal(),
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

// const primaryColor = Colors.blue;

class CheckoutModal extends StatefulWidget {
  const CheckoutModal({super.key});

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  String? selectedMethod;
  String? paymentType; // 'Pay Now' or 'Pay on Delivery'
  int currentStep = 1; // 1: Select payment type, 2: Payment details/delivery address

  // Form controllers
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final List<Map<String, String>> paymentMethods = [
    {
      'name': 'Orange Money',
      'image': 'assets/payment-logo/orange-money.png',
    },
    {
      'name': 'Master Card',
      'image': 'assets/payment-logo/mastercard.png',
    },
    {
      'name': 'Visa Card',
      'image': 'assets/payment-logo/visa.png',
    },
    {
      'name': 'Africell',
      'image': 'assets/payment-logo/afri-money.png',
    },
    {
      'name': 'Qcell',
      'image': 'assets/payment-logo/qmoney.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            AutoSizeText(
              "Checkout",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: secondaryColor
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Step 1: Select payment type
            if (currentStep == 1) ...[
              AutoSizeText(
                "Please select a payment type:",
                style: GoogleFonts.montserrat(
                  color: secondaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        paymentType = "Pay Now";
                        currentStep = 2;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade400,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(CupertinoIcons.creditcard, size: 32, color: secondaryColor),
                          const SizedBox(height: 8),
                          AutoSizeText(
                            "Pay Now",
                            style: GoogleFonts.montserrat(
                              color: Colors.black87,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        paymentType = "Pay on Delivery";
                        currentStep = 2;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade400,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(CupertinoIcons.home, size: 32, color: secondaryColor),
                          const SizedBox(height: 8),
                          AutoSizeText(
                            "Pay on Delivery",
                            style: GoogleFonts.montserrat(
                              color: Colors.black87,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Step 2: Payment details or delivery address
            if (currentStep == 2) ...[
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      currentStep = 1;
                      paymentType = null;
                      selectedMethod = null;
                    });
                  },
                ),
              ),

              AutoSizeText(
                paymentType ?? "",
                style: GoogleFonts.montserrat(
                  color: secondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Pay Now flow
              if (paymentType == "Pay Now") ...[
                AutoSizeText(
                  "Please select a payment method:",
                  style: GoogleFonts.montserrat(
                    color: secondaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Payment methods
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: paymentMethods.map((methodData) {
                    final method = methodData['name']!;
                    final imagePath = methodData['image']!;
                    final isSelected = selectedMethod == method;

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedMethod = method);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? secondaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                            isSelected ? primaryColor : Colors.grey.shade400,
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              imagePath,
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                            AutoSizeText(
                              method,
                              style: GoogleFonts.montserrat(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Payment form fields
                if (selectedMethod != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (["Orange Money", "Qcell", "Africell"]
                            .contains(selectedMethod)) ...[
                          TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                              prefixIcon: Icon(CupertinoIcons.phone),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: secondaryColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "PIN",
                              prefixIcon: Icon(CupertinoIcons.lock),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: secondaryColor, width: 2),
                              ),
                            ),
                          ),
                        ] else if (["Master Card", "Visa Card"]
                            .contains(selectedMethod)) ...[
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Card Number",
                              prefixIcon: Icon(CupertinoIcons.creditcard),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: secondaryColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "CVV",
                                    prefixIcon: Icon(CupertinoIcons.padlock),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: secondaryColor, width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    labelText: "Expiry Date (MM/YY)",
                                    prefixIcon: Icon(CupertinoIcons.calendar),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: secondaryColor, width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        // Delivery address for Pay Now
                        if (selectedMethod != null) ...[
                          const SizedBox(height: 24),
                          AutoSizeText(
                            "Delivery Information",
                            style: GoogleFonts.montserrat(
                              color: secondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: "Full Name",
                              prefixIcon: Icon(CupertinoIcons.person),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: secondaryColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: addressController,
                            decoration: const InputDecoration(
                              labelText: "Delivery Address",
                              prefixIcon: Icon(CupertinoIcons.location),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: secondaryColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (["Master Card", "Visa Card"].contains(selectedMethod))
                            TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: "Phone Number",
                                prefixIcon: Icon(CupertinoIcons.phone),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: secondaryColor, width: 2),
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
              ],

              // Pay on Delivery flow
              if (paymentType == "Pay on Delivery") ...[
                AutoSizeText(
                  "Please provide your delivery information:",
                  style: GoogleFonts.montserrat(
                    color: secondaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: Icon(CupertinoIcons.person),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(CupertinoIcons.phone),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Delivery Address",
                    prefixIcon: Icon(CupertinoIcons.location),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor, width: 2),
                    ),
                  ),
                ),
              ],
            ],

            const SizedBox(height: 24),

            // Continue button
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        if (currentStep == 1) {
                          // This shouldn't happen as the button is only shown in step 2
                          return;
                        }

                        if (paymentType == "Pay Now" && selectedMethod == null) {
                          // Show error or toast that payment method is required
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please select a payment method")),
                          );
                          return;
                        }

                        // Validate form fields
                        if (paymentType == "Pay on Delivery") {
                          if (nameController.text.isEmpty || 
                              phoneController.text.isEmpty || 
                              addressController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill all required fields")),
                            );
                            return;
                          }
                        } else if (paymentType == "Pay Now" && selectedMethod != null) {
                          if (nameController.text.isEmpty || addressController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill all required fields")),
                            );
                            return;
                          }
                        }

                        // Process the order
                        Navigator.of(context).pop();
                        // Here you would handle the order processing
                      },
                      height: 50,
                      color: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: AutoSizeText(
                          currentStep == 1 ? "Continue" : 
                            (paymentType == "Pay Now" ? "Complete Payment" : "Place Order"),
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: primaryColor,
                            fontWeight: FontWeight.w900
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
