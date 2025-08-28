import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/newpages/Pages/Payment.dart';
import '../components/colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _itemCount = 1;

  void _increaseCount() {
    setState(() {
      _itemCount++;
    });
  }

  void _decreaseCount() {
    if (_itemCount > 1) {
      setState(() {
        _itemCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: mainYellow,
        title: const Text("Cart"),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(Icons.chevron_right),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02), // Responsive spacing
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02, // Responsive padding
                ),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: size.height * 0.01),
                    decoration: BoxDecoration(
                      color: mainYellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        "assets/images/food.png",
                        width: size.width * 0.15, // Responsive image size
                        height: size.width * 0.15,
                        fit: BoxFit.contain,
                      ),
                      title: const Text("Cheese Burger"),
                      subtitle: const Text("100"),
                      trailing: Container(
                        constraints: BoxConstraints(
                          maxWidth:
                              size.width * 0.35,
                        ),
                        decoration: BoxDecoration(
                          color: mainYellow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: _decreaseCount,
                                icon: const Icon(Icons.remove),
                                color: mainBlack,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '$_itemCount',
                                style: TextStyle(
                                  fontSize:
                                      size.width * 0.06, // Responsive font size
                                ),
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                onPressed: _increaseCount,
                                icon: const Icon(Icons.add),
                                color: mainBlack,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: mainBlack.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPriceRow("Subtotal", "Le 1557.00", size),
                  SizedBox(height: size.height * 0.01),
                  _buildPriceRow("Delivery Fee", "Le 0.00", size),
                  _buildPriceRow("Total", "Le 1557.00", size, isTotal: true),
                  SizedBox(height: size.height * 0.02),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainYellow,
                      minimumSize: Size(size.width * 0.9, size.height * 0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PaymentPage()));
                    },
                    child: Text(
                      "Buy Now",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: size.width * 0.04,
                        color: mainBlack,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: padding.bottom), // Account for bottom safe area
                ],
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
              fontSize: size.width * 0.04,
              color: isTotal ? mainYellow : mainBlack,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: size.width * 0.04,
              color: isTotal ? mainYellow : mainBlack,
            ),
          ),
        ],
      ),
    );
  }
}
