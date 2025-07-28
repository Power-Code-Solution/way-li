import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/model/saved_cart_item.dart';
import 'package:wayli/app/newpages/components/colors.dart';

import 'order_history_controller.dart';

class OrderHistoryView extends GetView<OrderHistoryController> {
  static const routeName = 'order-history';
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => Get.offAllNamed('/bottom-nav'),
        ),
        title: Text(
          'Order History',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: secondaryColor),
            onPressed: () => controller.refreshOrders(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }

        if (controller.savedOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.doc_text_search,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 20),
                Text(
                  'No saved orders found',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your recent orders will appear here',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshOrders,
          color: primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.savedOrders.length,
            itemBuilder: (context, index) {
              final order = controller.savedOrders[index];
              return _buildOrderCard(context, order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(BuildContext context, SavedOrder order) {
    final remainingDays = controller.getRemainingDays(order.expiresAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id.substring(0, 8)}',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.getFormattedDate(order.savedAt),
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: secondaryColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Expires in $remainingDays days',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Order details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  icon: CupertinoIcons.location_solid,
                  title: 'Location',
                  value: order.location,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: CupertinoIcons.home,
                  title: 'Delivery Address',
                  value: order.deliveryAddress,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: CupertinoIcons.phone_fill,
                  title: 'Phone',
                  value: order.deliveryPhone,
                ),
                if (order.deliveryNotes != null && order.deliveryNotes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: CupertinoIcons.doc_text_fill,
                    title: 'Notes',
                    value: order.deliveryNotes!,
                  ),
                ],

                const Divider(height: 32),

                Text(
                  'Items',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Order items
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    return _buildItemCard(context, item);
                  },
                ),

                const Divider(height: 32),

                // Order total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                    Text(
                      'Le ${order.totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Order actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement reorder functionality
                      Get.snackbar(
                        'Reorder',
                        'This feature is coming soon!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: primaryColor,
                        colorText: secondaryColor,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 10,
                      );
                    },
                    icon: const Icon(CupertinoIcons.arrow_counterclockwise),
                    label: const Text('Reorder'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: secondaryColor.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(BuildContext context, SavedCartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Item image
          if (item.foodItem.foodItemsImages != null && 
              item.foodItem.foodItemsImages!.isNotEmpty &&
              item.foodItem.foodItemsImages![0].image != null)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item.foodItem.foodItemsImages![0].image!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                CupertinoIcons.photo,
                color: Colors.grey.shade500,
              ),
            ),

          const SizedBox(width: 12),

          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.foodItem.name ?? 'Unknown Item',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantity: ${item.quantity}',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Item price
          Text(
            'Le ${item.totalPrice.toStringAsFixed(2)}',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
