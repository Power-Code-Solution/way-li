class DeliveryFee {
  final int? id;
  final String address;
  final double fee;

  DeliveryFee({
    this.id,
    required this.address,
    required this.fee,
  });

  factory DeliveryFee.fromJson(Map<String, dynamic> json) {
    return DeliveryFee(
      id: _parseId(json['id'] ?? json['deliveryFeeId']),
      address: _parseAddress(json),
      fee: _parseFee(
        json['fee'] ?? json['deliveryFee'] ?? json['price'] ?? json['amount'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'fee': fee,
    };
  }

  static int? _parseId(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }

  static String _parseAddress(Map<String, dynamic> json) {
    final value = json['address'] ??
        json['location'] ??
        json['area'] ??
        json['name'];
    return (value ?? '').toString().trim();
  }

  static double _parseFee(dynamic value) {
    if (value == null) {
      return 0.0;
    }
    if (value is num) {
      return value.toDouble();
    }
    final raw = value.toString().trim();
    if (raw.isEmpty) {
      return 0.0;
    }
    final lower = raw.toLowerCase();
    if (lower == 'free') {
      return 0.0;
    }
    final normalized = lower
        .replaceAll('le', '')
        .replaceAll(',', '')
        .replaceAll(' ', '');
    final cleaned = normalized.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}
