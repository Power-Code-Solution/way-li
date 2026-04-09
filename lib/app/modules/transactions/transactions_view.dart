import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'transactions_controller.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionsController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Transaction History',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: secondaryColor),
            onPressed: () {
              // Show filter options
              controller.filterTransactions('all');
            },
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

        return controller.transactions.isEmpty
            ? _buildEmptyState()
            : Column(
                children: [
                  _buildSummaryCard(controller),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: controller.loadTransactions,
                      color: primaryColor,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = controller.transactions[index];
                          return _buildTransactionCard(transaction, controller);
                        },
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget _buildEmptyState() {
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
            'No Transactions Found',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your transaction history will appear here',
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

  Widget _buildSummaryCard(TransactionsController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            secondaryColor,
            secondaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                'Transaction Summary',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
                maxFontSize: 16,
                minFontSize: 10,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Last 30 Days',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                icon: CupertinoIcons.arrow_down_circle_fill,
                title: 'Total Spent',
                value: 'Le ${controller.totalSpent.value.toStringAsFixed(2)}',
              ),
              _buildSummaryItem(
                icon: CupertinoIcons.arrow_up_circle_fill,
                title: 'Total Refunds',
                value: 'Le ${controller.totalRefunds.value.toStringAsFixed(2)}',
              ),
              _buildSummaryItem(
                icon: CupertinoIcons.shopping_cart,
                title: 'Orders',
                value: '${controller.totalOrders.value}',
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 28,
        ),
        const SizedBox(height: 8),
        AutoSizeText(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: primaryColor.withOpacity(0.8),
          ),
          maxLines: 1,
          maxFontSize: 12,
          minFontSize: 8,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        AutoSizeText(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
          maxLines: 1,
          maxFontSize: 16,
          minFontSize: 10,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction, TransactionsController controller) {
    final bool isPayment = transaction['type'] == 'Payment';
    final bool isCompleted = transaction['status'] == 'Completed';
    final Color statusColor = isCompleted ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isPayment ? primaryColor.withOpacity(0.2) : Colors.red.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPayment ? CupertinoIcons.arrow_down : CupertinoIcons.arrow_up,
            color: isPayment ? secondaryColor : Colors.red,
            size: 20,
          ),
        ),
        title: AutoSizeText(
          transaction['description'],
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: secondaryColor,
          ),
          maxLines: 1,
          maxFontSize: 15,
          minFontSize: 10,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              controller.formatDate(transaction['date']),
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      transaction['status'],
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AutoSizeText(
                      transaction['type'],
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: secondaryColor,
                      ),
                      maxLines: 1,
                      maxFontSize: 10,
                      minFontSize: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: AutoSizeText(
          isPayment ? '-Le ${transaction['amount'].toStringAsFixed(2)}' : '+Le ${transaction['amount'].toStringAsFixed(2)}',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isPayment ? secondaryColor : Colors.green,
          ),
          maxLines: 1,
          maxFontSize: 16,
          minFontSize: 10,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 8),
                _buildTransactionDetail(
                  title: 'Transaction ID',
                  value: transaction['id'],
                ),
                _buildTransactionDetail(
                  title: 'Payment Method',
                  value: transaction['paymentMethod'],
                ),
                _buildTransactionDetail(
                  title: 'Date & Time',
                  value: controller.formatDate(transaction['date']),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        'Receipt',
                        'Viewing receipt for ${transaction['id']}',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: primaryColor,
                        colorText: secondaryColor,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: AutoSizeText(
                      'View Receipt',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      maxFontSize: 14,
                      minFontSize: 8,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildTransactionDetail({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            maxFontSize: 14,
            minFontSize: 8,
            overflow: TextOverflow.ellipsis,
          ),
          AutoSizeText(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: secondaryColor,
            ),
            maxLines: 1,
            maxFontSize: 12,
            minFontSize: 8,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
