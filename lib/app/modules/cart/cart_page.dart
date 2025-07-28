import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/modules/food_category/food_category_view.dart';
import '../../core/config/constants.dart';
import '../../newpages/components/colors.dart';
import 'cart_controller_fixed2.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool showCheckoutForm = false;
  String? selectedMethod;
  String? paymentType;
  int currentStep = 1;
  String? selectedLocation;
  final List<String> locations = ['RowdonStreet', 'Lumely', 'Eastern'];

  // Key to track the loading dialog
  final GlobalKey<State> _dialogKey = GlobalKey<State>();
  bool _isDialogShowing = false;

  // Method to safely dismiss the dialog
  void _dismissDialog(String source) {
    print("[DEBUG_LOG] Attempting to dismiss dialog from: $source");
    if (_isDialogShowing) {
      _isDialogShowing = false;
      try {
        // Try to pop the dialog directly without checking canPop
        Navigator.of(context, rootNavigator: true).pop();
        print("[DEBUG_LOG] Dialog dismissed successfully from: $source");
      } catch (e) {
        print("[DEBUG_LOG] Error dismissing dialog from: $source: $e");
        // If there's an error, try to use the dialog key to dismiss it
        if (_dialogKey.currentState != null && _dialogKey.currentContext != null) {
          try {
            Navigator.of(_dialogKey.currentContext!, rootNavigator: true).pop();
            print("[DEBUG_LOG] Dialog dismissed using dialog key from: $source");
          } catch (e2) {
            print("[DEBUG_LOG] Error dismissing dialog using key from: $source: $e2");
          }
        }
      }
      // Force rebuild the UI to ensure the loading dialog is gone
      setState(() {});
    } else {
      print("[DEBUG_LOG] Dialog is not showing, no need to dismiss from: $source");
    }
  }

  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final List<Map<String, String>> paymentMethods = [
    {
      'name': 'Orange Money',
      'image': 'assets/payment-logo/orange-money.png',
    },
  ];

  @override
  void dispose() {
    // Ensure the dialog is dismissed when the widget is disposed
    if (_isDialogShowing) {
      print("[DEBUG_LOG] Widget being disposed while dialog is showing, forcibly dismissing");
      _dismissDialog("dispose");
    }

    // Clean up controllers
    addressController.dispose();
    phoneController.dispose();
    nameController.dispose();
    notesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Get.offAllNamed('/bottom-nav'),
        ),
        backgroundColor: Colors.yellow,
        title: const Text("Cart"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            if (!showCheckoutForm) ...[
              // Cart items view
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
                                  "Le $price",
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
              // Cart summary and checkout button
              Obx(() {
                return Column(
                  children: [
                    if (cartController.getTotalPrice() > 0)
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
                                "Subtotal",
                                "Le ${cartController.getTotalPrice().toStringAsFixed(2)}",
                                size),
                            SizedBox(height: size.height * 0.01),
                            _buildPriceRow("Discount", "Le 0.00", size),
                            // Tax calculation commented out as requested
                            // _buildPriceRow(
                            //     "Tax (15%)",
                            //     "Le ${cartController.getTotalTax().toStringAsFixed(2)}",
                            //     size),
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
                                setState(() {
                                  showCheckoutForm = true;
                                  currentStep = 1;
                                  paymentType = null;
                                  selectedMethod = null;
                                });
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
                          ],
                        ),
                      )
                  ],
                );
              }),
            ] else ...[
              // Checkout form view
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.cart_fill,
                                color: secondaryColor,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Center(
                                  child: AutoSizeText(
                                    "Checkout",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24,
                                      color: secondaryColor
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (currentStep == 1) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.creditcard_fill, color: secondaryColor, size: 20),
                                    const SizedBox(width: 8),
                                    AutoSizeText(
                                      "Select Payment Method",
                                      style: GoogleFonts.montserrat(
                                        color: secondaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                AutoSizeText(
                                  "Choose how you'd like to pay for your order",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      paymentType = "Pay Now";
                                      currentStep = 2;
                                      selectedMethod = "Orange Money";
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: primaryColor.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(CupertinoIcons.creditcard_fill, size: 32, color: secondaryColor),
                                        ),
                                        const SizedBox(height: 12),
                                        AutoSizeText(
                                          "Pay Now",
                                          style: GoogleFonts.montserrat(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        AutoSizeText(
                                          "Orange Money",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      paymentType = "Pay on Delivery";
                                      currentStep = 2;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: primaryColor.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(CupertinoIcons.house_fill, size: 32, color: secondaryColor),
                                        ),
                                        const SizedBox(height: 12),
                                        AutoSizeText(
                                          "Pay on Delivery",
                                          style: GoogleFonts.montserrat(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        AutoSizeText(
                                          "Cash on Delivery",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (currentStep == 2) ...[
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

                          if (paymentType == "Pay Now") ...[
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primaryColor,
                                    primaryColor.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          'assets/payment-logo/orange-money.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              "Orange Money Payment",
                                              style: GoogleFonts.montserrat(
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 18,
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Fast, secure mobile payment",
                                              style: GoogleFonts.montserrat(
                                                color: secondaryColor.withOpacity(0.8),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Payment form fields
                            Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    "Payment Details",
                                    style: GoogleFonts.montserrat(
                                      color: secondaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  AutoSizeText(
                                    "Enter your Orange Money account information",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Orange Money input fields
                                  TextField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: "Phone Number",
                                      labelStyle: TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.phone, color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor, width: 2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    obscureText: true,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "PIN",
                                      labelStyle: TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.lock, color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor, width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Delivery Information Section
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.location_circle_fill, color: secondaryColor),
                                      const SizedBox(width: 8),
                                      AutoSizeText(
                                        "Delivery Information",
                                        style: GoogleFonts.montserrat(
                                          color: secondaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  AutoSizeText(
                                    "Tell us where to deliver your order",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Location dropdown
                                  DropdownButtonFormField<String>(
                                    value: selectedLocation,
                                    decoration: InputDecoration(
                                      labelText: "Select Location",
                                      labelStyle: TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.location_circle, color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor, width: 2),
                                      ),
                                    ),
                                    items: locations.map((location) {
                                      return DropdownMenuItem<String>(
                                        value: location,
                                        child: Text(location),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLocation = value;
                                      });
                                    },
                                    hint: const Text("Select a location"),
                                    icon: Icon(Icons.arrow_drop_down_circle, color: secondaryColor),
                                    dropdownColor: Colors.white,
                                    style: GoogleFonts.montserrat(
                                      color: secondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      labelText: "Full Name",
                                      labelStyle: TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.person, color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor, width: 2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: addressController,
                                    decoration: InputDecoration(
                                      labelText: "Delivery Address",
                                      labelStyle: TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.location, color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor, width: 2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: notesController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: "Delivery Notes",
                                      labelStyle: TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.doc_text, color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor, width: 2),
                                      ),
                                      hintText: "Special instructions for delivery",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Pay on Delivery flow
                          if (paymentType == "Pay on Delivery") ...[
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primaryColor,
                                    primaryColor.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Icon(CupertinoIcons.house, size: 30, color: secondaryColor),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              "Cash on Delivery",
                                              style: GoogleFonts.montserrat(
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 18,
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Pay when your order arrives",
                                              style: GoogleFonts.montserrat(
                                                color: secondaryColor.withOpacity(0.8),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Delivery Information Section
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(CupertinoIcons.location_circle_fill, color: secondaryColor),
                                      const SizedBox(width: 8),
                                      AutoSizeText(
                                        "Delivery Information",
                                        style: GoogleFonts.montserrat(
                                          color: secondaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  AutoSizeText(
                                    "Tell us where to deliver your order",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Location dropdown
                                  DropdownButtonFormField<String>(
                                    value: selectedLocation,
                                    decoration: InputDecoration(
                                      labelText: "Select Location",
                                      labelStyle: TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.location_circle, color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor, width: 2),
                                      ),
                                    ),
                                    items: locations.map((location) {
                                      return DropdownMenuItem<String>(
                                        value: location,
                                        child: Text(location),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLocation = value;
                                      });
                                    },
                                    hint: const Text("Select a location"),
                                    icon: Icon(Icons.arrow_drop_down_circle, color: secondaryColor),
                                    dropdownColor: Colors.white,
                                    style: GoogleFonts.montserrat(
                                      color: secondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      labelText: "Full Name",
                                      labelStyle: TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.person, color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor, width: 2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: "Phone Number",
                                      labelStyle: TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.phone, color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor, width: 2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: addressController,
                                    decoration: InputDecoration(
                                      labelText: "Delivery Address",
                                      labelStyle: TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.location, color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor, width: 2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: notesController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: "Delivery Notes",
                                      labelStyle: TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.doc_text, color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: primaryColor, width: 2),
                                      ),
                                      hintText: "Special instructions for delivery",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],

                        const SizedBox(height: 24),

                        // Continue button
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (currentStep == 1) {
                                // This shouldn't happen as the button is only shown in step 2
                                return;
                              }

                              if (paymentType == "Pay Now" && selectedMethod == null) {
                                // Show error or toast that payment method is required
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please select a payment method",
                                      style: GoogleFonts.montserrat(),
                                    ),
                                    backgroundColor: Colors.red.shade700,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Validate location
                              if (selectedLocation == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please select a location",
                                      style: GoogleFonts.montserrat(),
                                    ),
                                    backgroundColor: Colors.red.shade700,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Validate form fields
                              if (paymentType == "Pay on Delivery") {
                                if (nameController.text.isEmpty || 
                                    phoneController.text.isEmpty || 
                                    addressController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Please fill all required fields",
                                        style: GoogleFonts.montserrat(),
                                      ),
                                      backgroundColor: Colors.red.shade700,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                  return;
                                }
                              } else if (paymentType == "Pay Now" && selectedMethod != null) {
                                if (nameController.text.isEmpty || 
                                    phoneController.text.isEmpty || 
                                    addressController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Please fill all required fields",
                                        style: GoogleFonts.montserrat(),
                                      ),
                                      backgroundColor: Colors.red.shade700,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                  return;
                                }
                              }

                              // If a dialog is already showing, dismiss it first
                              if (_isDialogShowing) {
                                print("[DEBUG_LOG] Dialog already showing, dismissing before showing new one");
                                _dismissDialog("pre_show_check");
                              }

                              _isDialogShowing = true;

                              // Set up a safety timer to dismiss the dialog after 60 seconds
                              // This ensures the dialog doesn't stay open indefinitely if something goes wrong
                              Future.delayed(Duration(seconds: 60), () {
                                if (_isDialogShowing) {
                                  print("[DEBUG_LOG] Safety timer triggered, forcibly dismissing dialog");
                                  _dismissDialog("safety_timer_outside");
                                }
                              });

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  // Additional safety timer inside the dialog builder
                                  Future.delayed(Duration(seconds: 30), () {
                                    if (_isDialogShowing) {
                                      print("[DEBUG_LOG] Inner safety timer triggered");
                                      _dismissDialog("safety_timer_inside");
                                    }
                                  });
                                  return Dialog(
                                    key: _dialogKey,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                              strokeWidth: 3,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            "Processing Order...",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: secondaryColor,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Please wait while we process your order",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                              try {
                                print("[DEBUG_LOG] Starting order submission in cart_page");
                                final cartController = Get.find<CartController>();
                                print("[DEBUG_LOG] Found CartController, calling submitOrder");
                                final success = await cartController.submitOrder(
                                  location: selectedLocation!,
                                  deliveryAddress: addressController.text,
                                  deliveryPhone: phoneController.text,
                                  deliveryNotes: notesController.text,
                                );
                                print("[DEBUG_LOG] Order submission completed, success: $success");

                                // Close loading dialog
                                _dismissDialog("success_handler");

                                // Show success or error message
                                print("[DEBUG_LOG] Showing snackbar with message: ${cartController.orderSubmitMessage.value}");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      cartController.orderSubmitMessage.value,
                                      style: GoogleFonts.montserrat(),
                                    ),
                                    backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );

                                if (success) {
                                  print("[DEBUG_LOG] Order was successful, clearing cart");
                                  // Clear cart immediately
                                  cartController.clearCart();

                                  // Navigate to order history screen
                                  print("[DEBUG_LOG] Navigating to order history screen");
                                  Get.offAllNamed('/customer/order-history');
                                  print("[DEBUG_LOG] Navigation command executed");
                                } else {
                                  print("[DEBUG_LOG] Order was not successful, resetting form state");
                                  // If not successful, reset form state to allow user to try again

                                  // Check if error is related to location
                                  if (cartController.orderSubmitMessage.value.contains("Location not available")) {
                                    print("[DEBUG_LOG] Location error detected, resetting location selection");
                                    setState(() {
                                      showCheckoutForm = true;
                                      selectedLocation = null; // Reset location selection
                                      currentStep = 2; // Keep user on the same step to select a new location
                                    });
                                  } else {
                                    setState(() {
                                      showCheckoutForm = true;
                                    });
                                  }
                                }
                              } catch (e) {
                                print("[DEBUG_LOG] Exception caught during order submission: $e");
                                // Close loading dialog in case of error
                                _dismissDialog("error_handler");

                                // Show error message
                                print("[DEBUG_LOG] Showing error snackbar: ${e.toString()}");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Error: ${e.toString()}",
                                      style: GoogleFonts.montserrat(),
                                    ),
                                    backgroundColor: Colors.red.shade700,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );

                                // Reset form state to allow user to try again
                                print("[DEBUG_LOG] Resetting form state after exception");
                                setState(() {
                                  showCheckoutForm = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              foregroundColor: primaryColor,
                              minimumSize: const Size(double.infinity, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black.withOpacity(0.3),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  paymentType == "Pay Now" 
                                    ? CupertinoIcons.creditcard_fill 
                                    : CupertinoIcons.bag_fill,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  currentStep == 1 ? "Continue" : 
                                    (paymentType == "Pay Now" ? "Complete Payment" : "Place Order"),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
