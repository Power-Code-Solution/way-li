import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionsController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  final RxDouble totalSpent = 0.0.obs;
  final RxDouble totalRefunds = 0.0.obs;
  final RxInt totalOrders = 0.obs;
  
  // Sample transaction data - in a real app, this would come from an API or database
  final List<Map<String, dynamic>> sampleTransactions = [
    {
      'id': 'TRX-001',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'amount': 200.00,
      'type': 'Payment',
      'status': 'Completed',
      'description': 'Order #22 - Jollof Rice (2x)',
      'paymentMethod': 'Orange Money',
    },
    {
      'id': 'TRX-002',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'amount': 150.00,
      'type': 'Payment',
      'status': 'Completed',
      'description': 'Order #21 - Chicken Soup (1x)',
      'paymentMethod': 'Cash on Delivery',
    },
    {
      'id': 'TRX-003',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'amount': 50.00,
      'type': 'Refund',
      'status': 'Completed',
      'description': 'Refund for Order #20',
      'paymentMethod': 'Orange Money',
    },
    {
      'id': 'TRX-004',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'amount': 350.00,
      'type': 'Payment',
      'status': 'Completed',
      'description': 'Order #19 - Mixed Platter (1x)',
      'paymentMethod': 'Cash on Delivery',
    },
    {
      'id': 'TRX-005',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'amount': 180.00,
      'type': 'Payment',
      'status': 'Failed',
      'description': 'Order #18 - Fried Rice (1x)',
      'paymentMethod': 'Orange Money',
    },
  ];
  
  // Format date
  String formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    return dateFormat.format(date);
  }
  
  // Load transactions
  Future<void> loadTransactions() async {
    isLoading.value = true;
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // In a real app, you would fetch transactions from an API or database
      transactions.value = List.from(sampleTransactions);
      
      // Calculate summary values
      _calculateSummary();
    } catch (e) {
      print('Error loading transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Calculate summary values
  void _calculateSummary() {
    double spent = 0.0;
    double refunds = 0.0;
    int orders = 0;
    
    for (var transaction in transactions) {
      if (transaction['type'] == 'Payment' && transaction['status'] == 'Completed') {
        spent += transaction['amount'];
        orders++;
      } else if (transaction['type'] == 'Refund' && transaction['status'] == 'Completed') {
        refunds += transaction['amount'];
      }
    }
    
    totalSpent.value = spent;
    totalRefunds.value = refunds;
    totalOrders.value = orders;
  }
  
  // Filter transactions
  void filterTransactions(String filterType) {
    // Implement filtering logic based on filterType
    // e.g., 'all', 'payments', 'refunds', 'completed', 'failed'
    Get.snackbar(
      'Filter',
      'Filtering by $filterType',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }
  
  @override
  void onClose() {
    // Clean up any resources when the controller is closed
    super.onClose();
  }
}