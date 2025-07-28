import 'dart:convert';
import 'package:wayli/app/core/model/food_items.dart';

class SavedCartItem {
  final FoodItem foodItem;
  final int quantity;
  final double totalPrice;
  final DateTime savedAt;
  final DateTime expiresAt;

  SavedCartItem({
    required this.foodItem,
    required this.quantity,
    required this.totalPrice,
    required this.savedAt,
    required this.expiresAt,
  });

  factory SavedCartItem.fromJson(Map<String, dynamic> json) {
    return SavedCartItem(
      foodItem: FoodItem.fromJson(json['foodItem']),
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
      savedAt: DateTime.parse(json['savedAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodItem': foodItem.toJson(),
      'quantity': quantity,
      'totalPrice': totalPrice,
      'savedAt': savedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  bool isExpired() {
    return DateTime.now().isAfter(expiresAt);
  }
}

class SavedOrder {
  final String id;
  final List<SavedCartItem> items;
  final double totalAmount;
  final String location;
  final String deliveryAddress;
  final String deliveryPhone;
  final String? deliveryNotes;
  final DateTime savedAt;
  final DateTime expiresAt;

  SavedOrder({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.location,
    required this.deliveryAddress,
    required this.deliveryPhone,
    this.deliveryNotes,
    required this.savedAt,
    required this.expiresAt,
  });

  factory SavedOrder.fromJson(Map<String, dynamic> json) {
    return SavedOrder(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => SavedCartItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'],
      location: json['location'],
      deliveryAddress: json['deliveryAddress'],
      deliveryPhone: json['deliveryPhone'],
      deliveryNotes: json['deliveryNotes'],
      savedAt: DateTime.parse(json['savedAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'location': location,
      'deliveryAddress': deliveryAddress,
      'deliveryPhone': deliveryPhone,
      'deliveryNotes': deliveryNotes,
      'savedAt': savedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  bool isExpired() {
    return DateTime.now().isAfter(expiresAt);
  }

  static String encode(List<SavedOrder> orders) {
    return json.encode(
      orders.map<Map<String, dynamic>>((order) => order.toJson()).toList(),
    );
  }

  static List<SavedOrder> decode(String orders) {
    return (json.decode(orders) as List<dynamic>)
        .map<SavedOrder>((item) => SavedOrder.fromJson(item))
        .toList();
  }
}