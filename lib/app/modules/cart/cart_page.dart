import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/modules/food_category/food_category_view.dart';
import '../../core/config/constants.dart';
import '../../core/model/delivery_fee.dart';
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
  bool isDelivery = true;
  String? selectedLocation;
  final List<String> locations = ['Rawdon St', 'Lumely'];

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
  void initState() {
    super.initState();
    final cartController = Get.find<CartController>();
    cartController.fetchDeliveryFees();
    if (cartController.currentDeliveryAddress.isNotEmpty) {
      addressController.text = cartController.currentDeliveryAddress;
    }
  }

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery Required",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: size.width * 0.04,
                                    color: mainBlack,
                                  ),
                                ),
                                Switch(
                                  value: isDelivery,
                                  onChanged: (val) {
                                    setState(() {
                                      isDelivery = val;
                                      if (!isDelivery) {
                                        cartController.clearDeliveryFeeSelection();
                                        addressController.clear();
                                      } else {
                                        cartController.fetchDeliveryFees();
                                      }
                                    });
                                  },
                                  activeColor: Colors.yellow,
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            _buildPriceRow(
                                "Subtotal",
                                "Le ${cartController.getTotalPrice().toStringAsFixed(2)}",
                                size),
                            SizedBox(height: size.height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery Fee",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: size.width * 0.04,
                                    color: mainBlack,
                                  ),
                                ),
                                if (!isDelivery)
                                  Text(
                                    "Le 0.00",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: size.width * 0.04,
                                      color: mainBlack,
                                    ),
                                  )
                                else if (cartController.hasDeliveryFeeSelection)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Le ${cartController.currentDeliveryFee.toStringAsFixed(2)}",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: size.width * 0.04,
                                          color: mainBlack,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () {
                                          _showDeliveryAddressSheet(
                                              cartController, size);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: secondaryColor,
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          "Change",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            fontSize: size.width * 0.032,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  TextButton(
                                    onPressed: () {
                                      _showDeliveryAddressSheet(cartController, size);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: secondaryColor,
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Text(
                                      "Select address",
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        fontSize: size.width * 0.035,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              height: 10,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                            ),
                          _buildPriceRow(
                            "Total",
                            "Le ${cartController.getTotalWithDelivery(isDelivery).toStringAsFixed(2)}",
                            size,
                            isTotal: true,
                          ),
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
                                if (isDelivery &&
                                    !cartController.hasDeliveryFeeSelection) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Please select a delivery address",
                                        style: GoogleFonts.montserrat(),
                                      ),
                                      backgroundColor: Colors.red.shade700,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                  _showDeliveryAddressSheet(
                                      cartController, size);
                                  return;
                                }
                                setState(() {
                                  showCheckoutForm = true;
                                  currentStep = 2;
                                  paymentType = "Pay on Delivery";
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
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (currentStep == 2) ...[
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  setState(() {
                                    // Show the cart items again so user can add/remove
                                    showCheckoutForm = false;
                                    currentStep = 0;
                                    paymentType = null;
                                    selectedMethod = null;
                                  });
                                },
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  paymentType ?? "",
                                  style: GoogleFonts.montserrat(
                                    color: secondaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // This creates space on the right to center the text properly
                              const SizedBox(width: 48), // Same width as IconButton
                            ],
                          ),

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

                                  // Location selector (horizontal cards)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0, bottom: 8),
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.location_circle, color: secondaryColor, size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Select Nearest Location",
                                              style: GoogleFonts.montserrat(
                                                color: secondaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey.shade200),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(locations.length, (index) {
                                              final loc = locations[index];
                                              final bool isSelected = selectedLocation == loc;
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  left: index == 0 ? 12 : 8,
                                                  right: index == locations.length - 1 ? 12 : 8,
                                                ),
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(12),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedLocation = loc;
                                                    });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(milliseconds: 200),
                                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                                    constraints: BoxConstraints(
                                                      minWidth: size.width * 0.28,
                                                      maxWidth: size.width * 0.6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: isSelected ? primaryColor.withOpacity(0.3) : Colors.white,
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(
                                                        color: isSelected ? secondaryColor : Colors.grey.shade300,
                                                        width: isSelected ? 2 : 1,
                                                      ),
                                                      boxShadow: [
                                                        if (isSelected)
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.06),
                                                            blurRadius: 6,
                                                            offset: const Offset(0, 2),
                                                          ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          CupertinoIcons.location_solid,
                                                          size: 18,
                                                          color: isSelected ? secondaryColor : Colors.grey.shade600,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints(maxWidth: size.width * 0.5),
                                                          child: Text(
                                                            loc,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.montserrat(
                                                              color: isSelected ? secondaryColor : Colors.grey.shade800,
                                                              fontSize: 13,
                                                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        if (isSelected) ...[
                                                          const SizedBox(width: 8),
                                                          const Icon(CupertinoIcons.check_mark_circled_solid, size: 16, color: secondaryColor),
                                                        ]
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                  if (isDelivery)
                                    _buildDeliveryAddressSelector(cartController, size)
                                  else
                                    _buildPickupNotice(),
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(CupertinoIcons.location_circle_fill, color: secondaryColor),
                                          const SizedBox(width: 8),
                                          Expanded( // 👈 Prevents row overflow
                                            child: AutoSizeText(
                                              "Delivery Information",
                                              style: GoogleFonts.montserrat(
                                                color: secondaryColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0, bottom: 8),
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.location_circle, color: secondaryColor, size: 20),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                "Select Nearest Location",
                                                style: GoogleFonts.montserrat(
                                                  color: secondaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey.shade200),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(locations.length, (index) {
                                              final loc = locations[index];
                                              final bool isSelected = selectedLocation == loc;
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  left: index == 0 ? 12 : 8,
                                                  right: index == locations.length - 1 ? 12 : 8,
                                                ),
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(12),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedLocation = loc;
                                                    });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(milliseconds: 200),
                                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                                    constraints: BoxConstraints(
                                                      minWidth: size.width * 0.28,
                                                      maxWidth: size.width * 0.6, // 👈 prevents super-wide chips
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: isSelected ? primaryColor.withOpacity(0.3) : Colors.white,
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(
                                                        color: isSelected ? secondaryColor : Colors.grey.shade300,
                                                        width: isSelected ? 2 : 1,
                                                      ),
                                                      boxShadow: [
                                                        if (isSelected)
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.06),
                                                            blurRadius: 6,
                                                            offset: const Offset(0, 2),
                                                          ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          CupertinoIcons.location_solid,
                                                          size: 18,
                                                          color: isSelected ? secondaryColor : Colors.grey.shade600,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Flexible( // 👈 ensures text never pushes out of chip
                                                          child: Text(
                                                            loc,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: GoogleFonts.montserrat(
                                                              color: isSelected ? secondaryColor : Colors.grey.shade800,
                                                              fontSize: 13,
                                                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                        if (isSelected) ...[
                                                          const SizedBox(width: 8),
                                                          const Icon(
                                                            CupertinoIcons.check_mark_circled_solid,
                                                            size: 16,
                                                            color: secondaryColor,
                                                          ),
                                                        ]
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                  if (isDelivery)
                                    _buildDeliveryAddressSelector(cartController, size)
                                  else
                                    _buildPickupNotice(),
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
                              if (isDelivery && selectedLocation == null) {
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

                              if (isDelivery && !cartController.hasDeliveryFeeSelection) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please select a delivery address",
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
                                if (isDelivery && (nameController.text.isEmpty ||
                                    phoneController.text.isEmpty)) {
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
                                if (isDelivery && (nameController.text.isEmpty ||
                                    phoneController.text.isEmpty)) {
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
                                print("[DEBUG_LOG] Found CartController, calling submitOrder");
                                final success = await cartController.submitOrder(
                                  location: selectedLocation ?? "PICKUP",
                                  deliveryAddress: isDelivery ? addressController.text : "Pickup - will collect",
                                  deliveryPhone: phoneController.text,
                                  deliveryNotes: notesController.text,
                                  deliveryFee: isDelivery ? cartController.currentDeliveryFee : 0.0,
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
                                  cartController.clearCart();
                                  Get.offAllNamed('/customer/order-history');
                                } else {
                                  if (cartController.orderSubmitMessage.value.contains("Location not available")) {
                                    setState(() {
                                      showCheckoutForm = true;
                                      selectedLocation = null;
                                      currentStep = 2;
                                    });
                                  } else {
                                    setState(() {
                                      showCheckoutForm = true;
                                    });
                                  }
                                }
                              } catch (e) {
                                _dismissDialog("error_handler");
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

  Widget _buildDeliveryAddressSelector(CartController cartController, Size size) {
    return Obx(() {
      final DeliveryFee? selected = cartController.selectedDeliveryFee.value;
      final bool hasSelection = selected != null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery Address",
            style: GoogleFonts.montserrat(
              color: secondaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showDeliveryAddressSheet(cartController, size),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(CupertinoIcons.location, color: secondaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      hasSelection ? selected.address : "Select delivery area",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        color: hasSelection ? secondaryColor : Colors.grey.shade600,
                        fontWeight: hasSelection ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (hasSelection)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryColor.withOpacity(0.6)),
                      ),
                      child: Text(
                        "Le ${cartController.currentDeliveryFee.toStringAsFixed(2)}",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(CupertinoIcons.chevron_down, size: 18, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),
          if (!hasSelection)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "Select an address to show delivery fee.",
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildPickupNotice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.bag, color: secondaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Pickup selected. No delivery address needed.",
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeliveryAddressSheet(CartController cartController, Size size) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String searchTerm = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select delivery area",
                            style: GoogleFonts.montserrat(
                              color: secondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(CupertinoIcons.xmark_circle_fill),
                            color: Colors.grey.shade500,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      TextField(
                        onChanged: (value) {
                          setModalState(() {
                            searchTerm = value.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search by address",
                          prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey.shade600),
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
                      const SizedBox(height: 12),
                      Expanded(
                        child: Obx(() {
                          if (cartController.isDeliveryFeesLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                              ),
                            );
                          }

                          if (cartController.deliveryFeesError.value.isNotEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    cartController.deliveryFeesError.value,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.red.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () => cartController.fetchDeliveryFees(force: true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor,
                                      foregroundColor: primaryColor,
                                    ),
                                    child: Text(
                                      "Retry",
                                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final query = searchTerm.toLowerCase();
                          final fees = cartController.deliveryFees
                              .where((f) => f.address.toLowerCase().contains(query))
                              .toList();

                          if (fees.isEmpty) {
                            return Center(
                              child: Text(
                                "No addresses found.",
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            controller: scrollController,
                            itemCount: fees.length,
                            separatorBuilder: (_, __) => Divider(color: Colors.grey.shade200),
                            itemBuilder: (context, index) {
                              final fee = fees[index];
                              final selectedFee =
                                  cartController.selectedDeliveryFee.value;
                              final bool isSelected = selectedFee != null &&
                                  ((selectedFee.id != null &&
                                          fee.id != null &&
                                          selectedFee.id == fee.id) ||
                                      (selectedFee.id == null &&
                                          fee.id == null &&
                                          selectedFee.address.toLowerCase() ==
                                              fee.address.toLowerCase()));
                              return ListTile(
                                onTap: () {
                                  cartController.selectDeliveryFee(fee);
                                  addressController.text = fee.address;
                                  Navigator.pop(context);
                                },
                                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                                title: Text(
                                  fee.address,
                                  style: GoogleFonts.montserrat(
                                    color: secondaryColor,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: primaryColor.withOpacity(0.6)),
                                  ),
                                  child: Text(
                                    "Le ${fee.fee.toStringAsFixed(2)}",
                                    style: GoogleFonts.montserrat(
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
