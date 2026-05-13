import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayli/app/modules/food_category/food_category_view.dart';

import '../../core/config/auth_controller.dart';
import '../../core/config/constants.dart';
import '../../core/model/delivery_fee.dart';
import '../../core/model/monime_payment_response.dart';
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
  bool _isMonimeDialogOpen = false;
  bool _isCheckingMonimeStatus = false;
  bool _isRegeneratingMonimeCode = false;
  bool _isFinalizingPaidMonimeOrder = false;
  Duration _monimeTimeRemaining = Duration.zero;
  Timer? _monimePollingTimer;
  Timer? _monimeCountdownTimer;

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
        if (_dialogKey.currentState != null &&
            _dialogKey.currentContext != null) {
          try {
            Navigator.of(_dialogKey.currentContext!, rootNavigator: true).pop();
            print(
                "[DEBUG_LOG] Dialog dismissed using dialog key from: $source");
          } catch (e2) {
            print(
                "[DEBUG_LOG] Error dismissing dialog using key from: $source: $e2");
          }
        }
      }
      // Force rebuild the UI to ensure the loading dialog is gone
      setState(() {});
    } else {
      print(
          "[DEBUG_LOG] Dialog is not showing, no need to dismiss from: $source");
    }
  }

  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final List<Map<String, String>> paymentMethods = [
    {
      'name': 'Monime',
      'image': 'assets/payment-logo/monime.png',
    },
  ];

  late final Worker _monimeStatusWorker;

  @override
  void initState() {
    super.initState();
    final cartController = Get.find<CartController>();
    cartController.fetchDeliveryFees();
    if (cartController.currentDeliveryAddress.isNotEmpty) {
      addressController.text = cartController.currentDeliveryAddress;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final shouldOpenCheckout =
          Get.arguments is Map && Get.arguments["openCheckout"] == true;
      if (!shouldOpenCheckout) {
        return;
      }

      final authController = Get.find<AuthController>();
      await authController.checkLoginStatus();
      if (!mounted || !authController.isLoggedIn.value) {
        return;
      }

      setState(() {
        showCheckoutForm = true;
        currentStep = 1;
        paymentType = null;
        selectedMethod = null;
      });
    });

    // Listen for Monime payment success
    _monimeStatusWorker =
        ever(cartController.monimePaymentResult, (result) async {
      if (result == null ||
          !result.isSuccessful ||
          _isFinalizingPaidMonimeOrder) {
        return;
      }

      _isFinalizingPaidMonimeOrder = true;
      final orderSaved = await _finalizePaidMonimeOrder(result);
      if (!orderSaved && mounted) {
        setState(() {
          showCheckoutForm = true;
          currentStep = 2;
        });
      }
      _isFinalizingPaidMonimeOrder = false;
    });
  }

  @override
  void dispose() {
    _monimeStatusWorker.dispose();
    _disposeMonimeTimers();
    // Ensure the dialog is dismissed when the widget is disposed
    if (_isDialogShowing) {
      print(
          "[DEBUG_LOG] Widget being disposed while dialog is showing, forcibly dismissing");
      _dismissDialog("dispose");
    }

    // Clean up controllers
    addressController.dispose();
    phoneController.dispose();
    nameController.dispose();
    notesController.dispose();

    super.dispose();
  }

  Future<void> _startCheckoutFlow(
    CartController cartController,
  ) async {
    final authController = Get.find<AuthController>();
    final canContinue = await authController.ensureAuthenticated(
      redirectToCheckout: true,
      message: "Please sign in before proceeding to checkout.",
    );
    if (!canContinue || !mounted) {
      return;
    }

    setState(() {
      showCheckoutForm = true;
      currentStep = 1;
      paymentType = null;
      selectedMethod = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                                    image: NetworkImage((item.foodItemsImages !=
                                                null &&
                                            item.foodItemsImages!.isNotEmpty)
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
                                    onPressed: () => cartController
                                        .decreaseQuantity(item.id ?? 0),
                                    icon: const Icon(Icons.remove),
                                    color: mainBlack,
                                  ),
                                  AutoSizeText(
                                    '${cartController.itemQuantities[item.id]?.value}',
                                    style: GoogleFonts.montserrat(
                                        fontSize: size.width * 0.06),
                                  ),
                                  IconButton(
                                    onPressed: () => cartController
                                        .increaseQuantity(item.id ?? 0),
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
                                        cartController
                                            .clearDeliveryFeeSelection();
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
                                      _showDeliveryAddressSheet(
                                          cartController, size);
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
                              onPressed: () =>
                                  _startCheckoutFlow(cartController),
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
                        if (currentStep == 1) ...[
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  setState(() {
                                    showCheckoutForm = false;
                                    currentStep = 0;
                                    paymentType = null;
                                    selectedMethod = null;
                                  });
                                },
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  "Payment Method",
                                  style: GoogleFonts.montserrat(
                                    color: secondaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Choose how you want to pay",
                                  style: GoogleFonts.montserrat(
                                    color: secondaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Start by selecting either Pay now or Pay on delivery. After that, we will collect the customer details and delivery information.",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTypeButton(
                                  "Pay Now",
                                  CupertinoIcons.creditcard,
                                  paymentType == "Pay Now",
                                  () => setState(() => paymentType = "Pay Now"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTypeButton(
                                  "Pay on Delivery",
                                  CupertinoIcons.bag,
                                  paymentType == "Pay on Delivery",
                                  () => setState(
                                      () => paymentType = "Pay on Delivery"),
                                ),
                              ),
                            ],
                          ),
                          if (paymentType == "Pay Now") ...[
                            const SizedBox(height: 24),
                            AutoSizeText(
                              "Select Payment Provider",
                              style: GoogleFonts.montserrat(
                                color: secondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...paymentMethods.map((method) {
                              bool isSelected =
                                  selectedMethod == method['name'];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? primaryColor
                                        : Colors.grey.shade200,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      selectedMethod = method['name'];
                                    });
                                  },
                                  leading: Image.asset(
                                    method['image']!,
                                    width: 40,
                                    height: 40,
                                  ),
                                  title: Text(
                                    method['name']!,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  trailing: Icon(
                                    isSelected
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color:
                                        isSelected ? primaryColor : Colors.grey,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ],

                        if (currentStep == 2) ...[
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  setState(() {
                                    currentStep = 1;
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
                              const SizedBox(
                                  width: 48), // Same width as IconButton
                            ],
                          ),

                          if (paymentType == "Pay Now" &&
                              selectedMethod == "Monime") ...[
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
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
                                      Container(
                                        width: 58,
                                        height: 58,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.18),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Image.asset(
                                          'assets/payment-logo/monime.png',
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                            CupertinoIcons.creditcard,
                                            size: 30,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Monime Payment",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: secondaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Enter the customer details below, then we will generate a secure Monime payment code.",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                color: Colors.grey.shade700,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                    ),
                                    child: Text(
                                      "The payment code will stay active for 10 minutes. If it expires, the customer can generate a new one.",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildDeliveryInfoSection(
                              size,
                              includePhoneField: true,
                              title: "Customer & Delivery Details",
                              subtitle:
                                  "Provide the customer name, phone number, and delivery preference before generating the payment code.",
                            ),
                          ] else if (paymentType == "Pay Now" &&
                              selectedMethod == "Orange Money") ...[
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
                              child: Row(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            color:
                                                secondaryColor.withOpacity(0.8),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                  TextField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: "Phone Number",
                                      labelStyle:
                                          TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.phone,
                                          color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    obscureText: true,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "PIN",
                                      labelStyle:
                                          TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.lock,
                                          color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildDeliveryInfoSection(
                              size,
                              includePhoneField: false,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                              CupertinoIcons
                                                  .location_circle_fill,
                                              color: secondaryColor),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            // 👈 Prevents row overflow
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
                                        padding: const EdgeInsets.only(
                                            left: 4.0, bottom: 8),
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.location_circle,
                                                color: secondaryColor,
                                                size: 20),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey.shade200),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(
                                                locations.length, (index) {
                                              final loc = locations[index];
                                              final bool isSelected =
                                                  selectedLocation == loc;
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  left: index == 0 ? 12 : 8,
                                                  right: index ==
                                                          locations.length - 1
                                                      ? 12
                                                      : 8,
                                                ),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedLocation = loc;
                                                    });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 14,
                                                        vertical: 10),
                                                    constraints: BoxConstraints(
                                                      minWidth:
                                                          size.width * 0.28,
                                                      maxWidth: size.width *
                                                          0.6, // 👈 prevents super-wide chips
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? primaryColor
                                                              .withOpacity(0.3)
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                        color: isSelected
                                                            ? secondaryColor
                                                            : Colors
                                                                .grey.shade300,
                                                        width:
                                                            isSelected ? 2 : 1,
                                                      ),
                                                      boxShadow: [
                                                        if (isSelected)
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.06),
                                                            blurRadius: 6,
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          CupertinoIcons
                                                              .location_solid,
                                                          size: 18,
                                                          color: isSelected
                                                              ? secondaryColor
                                                              : Colors.grey
                                                                  .shade600,
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Flexible(
                                                          // 👈 ensures text never pushes out of chip
                                                          child: Text(
                                                            loc,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              color: isSelected
                                                                  ? secondaryColor
                                                                  : Colors.grey
                                                                      .shade800,
                                                              fontSize: 13,
                                                              fontWeight: isSelected
                                                                  ? FontWeight
                                                                      .w700
                                                                  : FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        if (isSelected) ...[
                                                          const SizedBox(
                                                              width: 8),
                                                          const Icon(
                                                            CupertinoIcons
                                                                .check_mark_circled_solid,
                                                            size: 16,
                                                            color:
                                                                secondaryColor,
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
                                      labelStyle:
                                          TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.person,
                                          color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: "Phone Number",
                                      labelStyle:
                                          TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.phone,
                                          color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  if (isDelivery)
                                    _buildDeliveryAddressSelector(
                                        cartController, size)
                                  else
                                    _buildPickupNotice(),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: notesController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: "Delivery Notes",
                                      labelStyle:
                                          TextStyle(color: secondaryColor),
                                      prefixIcon: Icon(CupertinoIcons.doc_text,
                                          color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade200),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                      ),
                                      hintText:
                                          "Special instructions for delivery",
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
                                if (paymentType == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: const Text(
                                            "Please select payment type")),
                                  );
                                  return;
                                }
                                if (paymentType == "Pay Now" &&
                                    selectedMethod == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: const Text(
                                            "Please select payment provider")),
                                  );
                                  return;
                                }
                                setState(() {
                                  currentStep = 2;
                                });
                                return;
                              }

                              if (paymentType == "Pay Now" &&
                                  selectedMethod == null) {
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
                                return;
                              }

                              // Validate form fields
                              if (paymentType == "Pay on Delivery") {
                                if (nameController.text.trim().isEmpty ||
                                    phoneController.text.trim().isEmpty) {
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
                                if (!_isValidPhoneNumber(
                                    phoneController.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Please enter a valid phone number",
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
                              } else if (paymentType == "Pay Now" &&
                                  selectedMethod != null) {
                                if (nameController.text.trim().isEmpty ||
                                    phoneController.text.trim().isEmpty) {
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
                                if (!_isValidPhoneNumber(
                                    phoneController.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Please enter a valid phone number",
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

                              try {
                                if (paymentType == "Pay Now" &&
                                    selectedMethod == "Monime") {
                                  _showBlockingProgressDialog(
                                    title: "Generating Code...",
                                    message:
                                        "Please wait while we prepare your Monime payment.",
                                  );

                                  final monimeResult = await cartController
                                      .initiateMonimePayment(
                                    amount: cartController
                                        .getTotalWithDelivery(isDelivery),
                                    customerName: nameController.text.trim(),
                                    phoneNumber: phoneController.text.trim(),
                                  );

                                  _dismissDialog("monime_initiate");

                                  if (monimeResult != null) {
                                    _showMonimePaymentDialog(
                                      result: monimeResult,
                                      amount: cartController
                                          .getTotalWithDelivery(isDelivery),
                                      customerName: nameController.text.trim(),
                                      phoneNumber: phoneController.text.trim(),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          cartController.monimeError.value,
                                          style: GoogleFonts.montserrat(),
                                        ),
                                        backgroundColor: Colors.red.shade700,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      showCheckoutForm = true;
                                    });
                                  }
                                  return;
                                }

                                _showBlockingProgressDialog(
                                  title: "Processing Order...",
                                  message:
                                      "Please wait while we process your order.",
                                );

                                final success =
                                    await cartController.submitOrder(
                                  location: selectedLocation ?? "PICKUP",
                                  deliveryAddress: isDelivery
                                      ? addressController.text
                                      : "Pickup - will collect",
                                  deliveryPhone: phoneController.text,
                                  deliveryNotes: notesController.text,
                                  deliveryFee: isDelivery
                                      ? cartController.currentDeliveryFee
                                      : 0.0,
                                );
                                _dismissDialog("success_handler");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      cartController.orderSubmitMessage.value,
                                      style: GoogleFonts.montserrat(),
                                    ),
                                    backgroundColor: success
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
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
                                  if (cartController.orderSubmitMessage.value
                                      .contains("Location not available")) {
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
                                  currentStep == 1
                                      ? CupertinoIcons.arrow_right_circle_fill
                                      : (paymentType == "Pay Now"
                                          ? CupertinoIcons.creditcard_fill
                                          : CupertinoIcons.bag_fill),
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  currentStep == 1
                                      ? "Continue to Details"
                                      : (paymentType == "Pay Now"
                                          ? "Generate Payment Code"
                                          : "Place Order"),
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

  Widget _buildDeliveryInfoSection(
    Size size, {
    bool includePhoneField = false,
    String title = "Delivery Information",
    String subtitle = "Where should we send your order?",
  }) {
    return Container(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(CupertinoIcons.location_circle_fill,
                      color: secondaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AutoSizeText(
                      title,
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
              const SizedBox(height: 4),
              AutoSizeText(
                subtitle,
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      "Delivery",
                      CupertinoIcons.car,
                      isDelivery,
                      () => setState(() => isDelivery = true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeButton(
                      "Pickup",
                      CupertinoIcons.bag,
                      !isDelivery,
                      () => setState(() => isDelivery = false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (isDelivery) ...[
                _buildLocationSelector(size),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: TextStyle(color: secondaryColor),
                  prefixIcon:
                      Icon(CupertinoIcons.person, color: secondaryColor),
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
              if (includePhoneField) ...[
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter the customer phone number",
                    labelStyle: TextStyle(color: secondaryColor),
                    prefixIcon:
                        Icon(CupertinoIcons.phone, color: secondaryColor),
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
              ],
              if (isDelivery)
                _buildDeliveryAddressSelector(Get.find<CartController>(), size)
              else
                _buildPickupNotice(),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Delivery Notes",
                  labelStyle: TextStyle(color: secondaryColor),
                  prefixIcon:
                      Icon(CupertinoIcons.doc_text, color: secondaryColor),
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
        ],
      ),
    );
  }

  Widget _buildLocationSelector(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          "Select Area",
          style: GoogleFonts.montserrat(
            color: secondaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              final isSelected = selectedLocation == location;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => setState(() => selectedLocation = location),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? primaryColor : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        location,
                        style: GoogleFonts.montserrat(
                          color: isSelected
                              ? secondaryColor
                              : Colors.grey.shade700,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showBlockingProgressDialog({
    required String title,
    required String message,
  }) {
    if (_isDialogShowing) {
      _dismissDialog("replace_progress_dialog");
    }

    _isDialogShowing = true;

    Future.delayed(const Duration(seconds: 60), () {
      if (_isDialogShowing) {
        _dismissDialog("safety_timer_outside");
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 30), () {
          if (_isDialogShowing) {
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
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
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
  }

  Future<bool> _finalizePaidMonimeOrder(MonimePaymentResult result) async {
    final cartController = Get.find<CartController>();

    _disposeMonimeTimers();
    if (_isMonimeDialogOpen &&
        mounted &&
        Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    _isMonimeDialogOpen = false;

    if (!mounted) {
      return false;
    }

    _showBlockingProgressDialog(
      title: "Confirming Order...",
      message: "Saving your paid order now.",
    );

    final success = await cartController.submitOrder(
      location: isDelivery ? (selectedLocation ?? "PICKUP") : "PICKUP",
      deliveryAddress:
          isDelivery ? addressController.text.trim() : "Pickup - will collect",
      deliveryPhone: phoneController.text.trim(),
      deliveryNotes: notesController.text.trim(),
      deliveryFee: isDelivery ? cartController.currentDeliveryFee : 0.0,
      monimePaymentId: result.id,
    );

    if (!mounted) {
      return success;
    }

    _dismissDialog("finalize_paid_monime_order");

    final message = success
        ? "Payment confirmed and order placed successfully."
        : (cartController.orderSubmitMessage.value.isNotEmpty
            ? "Payment received, but the order could not be saved yet. ${cartController.orderSubmitMessage.value}"
            : "Payment received, but the order could not be saved yet.");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor:
            success ? Colors.green.shade700 : Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    if (success) {
      cartController.clearCart();
      Get.offAllNamed('/customer/order-history');
    }

    return success;
  }

  void _showMonimePaymentDialog({
    required MonimePaymentResult result,
    required double amount,
    required String customerName,
    required String phoneNumber,
  }) {
    final cartController = Get.find<CartController>();
    bool hasStartedTracking = false;

    cartController.monimePaymentResult.value = result;
    _disposeMonimeTimers();
    _monimeTimeRemaining = result.remainingTime;
    _isMonimeDialogOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          if (!hasStartedTracking) {
            hasStartedTracking = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              _refreshMonimeCountdown(
                cartController.monimePaymentResult.value ?? result,
                setDialogState,
              );
              _startMonimeStatusPolling(setDialogState);
            });
          }

          return Obx(() {
            final currentResult =
                cartController.monimePaymentResult.value ?? result;
            final isSuccessful = currentResult.isSuccessful;
            final hasTimedOut =
                currentResult.remainingTime == Duration.zero && !isSuccessful;
            final isExpired = currentResult.isExpired || hasTimedOut;
            final isFailed =
                currentResult.isTerminal && !isSuccessful && !isExpired;
            final statusValue = isExpired ? 'expired' : currentResult.status;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(9),
                            child: Image.asset(
                              'assets/payment-logo/monime.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Monime Payment",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: secondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _monimeStatusColor(statusValue)
                                        .withOpacity(0.14),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    _formatMonimeStatus(statusValue),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: _monimeStatusColor(statusValue),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Dial this code",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SelectableText(
                              currentResult.ussdCode,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: secondaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                            text: currentResult.ussdCode),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Payment code copied to clipboard",
                                            style: GoogleFonts.montserrat(),
                                          ),
                                          backgroundColor:
                                              Colors.green.shade700,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.copy_rounded,
                                        size: 18),
                                    label: const Text("Copy"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _launchMonimeDialer(
                                        currentResult.ussdCode),
                                    icon: const Icon(
                                        Icons.phone_in_talk_rounded,
                                        size: 18),
                                    label: const Text("Dial"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade600,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (isSuccessful) ...[
                        _buildMonimeStatusBanner(
                          icon: CupertinoIcons.checkmark_circle_fill,
                          iconColor: Colors.green,
                          title: "Payment received",
                          description: "Confirming your order.",
                          backgroundColor: Colors.green.shade50,
                          borderColor: Colors.green.shade100,
                        ),
                      ] else if (isExpired) ...[
                        _buildMonimeStatusBanner(
                          icon: CupertinoIcons.time_solid,
                          iconColor: Colors.orange.shade700,
                          title: "Code expired",
                          description: "Generate a new code.",
                          backgroundColor: Colors.orange.shade50,
                          borderColor: Colors.orange.shade100,
                        ),
                      ] else if (isFailed) ...[
                        _buildMonimeStatusBanner(
                          icon: CupertinoIcons.exclamationmark_triangle_fill,
                          iconColor: Colors.red.shade700,
                          title: "Session closed",
                          description: "Generate a fresh code.",
                          backgroundColor: Colors.red.shade50,
                          borderColor: Colors.red.shade100,
                        ),
                      ] else ...[
                        _buildMonimeStatusBanner(
                          icon: CupertinoIcons.time,
                          iconColor: secondaryColor,
                          title: "Waiting for payment",
                          description: "We will update this automatically.",
                          backgroundColor: Colors.yellow.shade50,
                          borderColor: Colors.yellow.shade100,
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Expires in ${_formatMonimeDuration(_monimeTimeRemaining)}",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      if (!isSuccessful && (isExpired || isFailed))
                        ElevatedButton.icon(
                          onPressed: _isRegeneratingMonimeCode
                              ? null
                              : () => _regenerateMonimePayment(
                                    setDialogState: setDialogState,
                                    amount: amount,
                                    customerName: customerName,
                                    phoneNumber: phoneNumber,
                                  ),
                          icon: _isRegeneratingMonimeCode
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.refresh_rounded),
                          label: Text(
                            _isRegeneratingMonimeCode
                                ? "Generating..."
                                : "Generate New Code",
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          _disposeMonimeTimers();
                          _isMonimeDialogOpen = false;
                          Navigator.pop(context);
                        },
                        child: Text(
                          isSuccessful ? "Close" : "Cancel",
                          style: GoogleFonts.montserrat(
                            color: isSuccessful
                                ? secondaryColor
                                : Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
      },
    ).then((_) {
      _disposeMonimeTimers();
      _isMonimeDialogOpen = false;
    });
  }

  void _refreshMonimeCountdown(
    MonimePaymentResult currentResult,
    StateSetter setDialogState,
  ) {
    if (!mounted) {
      return;
    }

    final remaining = currentResult.remainingTime;
    setDialogState(() {
      _monimeTimeRemaining = remaining;
    });
  }

  void _disposeMonimeTimers() {
    _monimePollingTimer?.cancel();
    _monimeCountdownTimer?.cancel();
    _monimePollingTimer = null;
    _monimeCountdownTimer = null;
    _isCheckingMonimeStatus = false;
    _isRegeneratingMonimeCode = false;
    _monimeTimeRemaining = Duration.zero;
  }

  void _startMonimeStatusPolling(StateSetter setDialogState) {
    final cartController = Get.find<CartController>();
    _disposeMonimeTimers();
    final initialResult = cartController.monimePaymentResult.value;
    if (initialResult != null) {
      _refreshMonimeCountdown(initialResult, setDialogState);
    }

    _monimeCountdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !_isMonimeDialogOpen) {
        _disposeMonimeTimers();
        return;
      }

      final currentResult = cartController.monimePaymentResult.value;
      if (currentResult == null) {
        return;
      }

      _refreshMonimeCountdown(currentResult, setDialogState);
      if (currentResult.isTerminal ||
          currentResult.remainingTime == Duration.zero) {
        _monimeCountdownTimer?.cancel();
      }
    });

    _monimePollingTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      final currentResult = cartController.monimePaymentResult.value;
      if (!mounted || !_isMonimeDialogOpen || currentResult == null) {
        _disposeMonimeTimers();
        return;
      }

      if (_isCheckingMonimeStatus ||
          currentResult.isTerminal ||
          currentResult.remainingTime == Duration.zero) {
        if (currentResult.isTerminal ||
            currentResult.remainingTime == Duration.zero) {
          timer.cancel();
        }
        return;
      }

      _isCheckingMonimeStatus = true;
      final latestResult =
          await cartController.checkMonimePaymentStatus(currentResult.id);
      _isCheckingMonimeStatus = false;

      if (!mounted || !_isMonimeDialogOpen) {
        return;
      }

      final refreshedResult =
          latestResult ?? cartController.monimePaymentResult.value;
      if (refreshedResult != null) {
        _refreshMonimeCountdown(refreshedResult, setDialogState);
        if (refreshedResult.isTerminal ||
            refreshedResult.remainingTime == Duration.zero) {
          timer.cancel();
        }
      }
    });
  }

  Future<void> _regenerateMonimePayment({
    required StateSetter setDialogState,
    required double amount,
    required String customerName,
    required String phoneNumber,
  }) async {
    final cartController = Get.find<CartController>();
    if (_isRegeneratingMonimeCode) {
      return;
    }

    setDialogState(() {
      _isRegeneratingMonimeCode = true;
    });

    final newResult = await cartController.initiateMonimePayment(
      amount: amount,
      customerName: customerName,
      phoneNumber: phoneNumber,
    );

    if (!mounted) {
      return;
    }

    if (newResult == null) {
      setDialogState(() {
        _isRegeneratingMonimeCode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cartController.monimeError.value,
            style: GoogleFonts.montserrat(),
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    cartController.monimePaymentResult.value = newResult;
    setDialogState(() {
      _isRegeneratingMonimeCode = false;
      _monimeTimeRemaining = newResult.remainingTime;
    });
    _startMonimeStatusPolling(setDialogState);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "A new Monime payment code has been generated.",
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  Future<void> _launchMonimeDialer(String ussdCode) async {
    final launchUri = Uri.parse('tel:${Uri.encodeComponent(ussdCode)}');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
      return;
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Could not open your dialer automatically",
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  Widget _buildMonimeStatusBanner({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 8;
  }

  String _formatMonimeDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _formatMonimeStatus(String status) {
    final normalized = status.trim().toLowerCase();
    switch (normalized) {
      case 'paid':
        return 'Paid';
      case 'completed':
        return 'Completed';
      case 'expired':
        return 'Expired';
      case 'failed':
        return 'Failed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return normalized.isEmpty
            ? 'Pending'
            : '${normalized[0].toUpperCase()}${normalized.substring(1)}';
    }
  }

  Color _monimeStatusColor(String status) {
    switch (status.trim().toLowerCase()) {
      case 'paid':
      case 'completed':
        return Colors.green;
      case 'expired':
        return Colors.orange;
      case 'failed':
      case 'cancelled':
        return Colors.red;
      default:
        return secondaryColor;
    }
  }

  Widget _buildTypeButton(
      String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18, color: isSelected ? secondaryColor : Colors.grey),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: isSelected ? secondaryColor : Colors.grey,
              ),
            ),
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

  Widget _buildDeliveryAddressSelector(
      CartController cartController, Size size) {
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
                        color: hasSelection
                            ? secondaryColor
                            : Colors.grey.shade600,
                        fontWeight:
                            hasSelection ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (hasSelection)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: primaryColor.withOpacity(0.6)),
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
                  Icon(CupertinoIcons.chevron_down,
                      size: 18, color: Colors.grey.shade600),
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
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
                          prefixIcon: Icon(CupertinoIcons.search,
                              color: Colors.grey.shade600),
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
                            borderSide:
                                BorderSide(color: primaryColor, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Obx(() {
                          if (cartController.isDeliveryFeesLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(primaryColor),
                              ),
                            );
                          }

                          if (cartController
                              .deliveryFeesError.value.isNotEmpty) {
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
                                    onPressed: () => cartController
                                        .fetchDeliveryFees(force: true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor,
                                      foregroundColor: primaryColor,
                                    ),
                                    child: Text(
                                      "Retry",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final query = searchTerm.toLowerCase();
                          final fees = cartController.deliveryFees
                              .where((f) =>
                                  f.address.toLowerCase().contains(query))
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
                            separatorBuilder: (_, __) =>
                                Divider(color: Colors.grey.shade200),
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
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                title: Text(
                                  fee.address,
                                  style: GoogleFonts.montserrat(
                                    color: secondaryColor,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: primaryColor.withOpacity(0.6)),
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
