class MonimePaymentResponse {
  final bool success;
  final List<String> messages;
  final MonimePaymentResult? result;
  final int? statusCode;
  final String? message;

  MonimePaymentResponse({
    required this.success,
    required this.messages,
    this.result,
    this.statusCode,
    this.message,
  });

  factory MonimePaymentResponse.fromJson(Map<String, dynamic> json) {
    final dynamic payload = json['data'] ?? json['result'];
    final dynamic rawMessages = json['messages'];
    final String? message = json['message']?.toString();

    return MonimePaymentResponse(
      success: (json['success'] == true) || (json['status'] == 1),
      messages: rawMessages is List
          ? rawMessages.map((item) => item.toString()).toList()
          : (message != null && message.isNotEmpty
              ? <String>[message]
              : <String>[]),
      result: payload is Map
          ? MonimePaymentResult.fromJson(Map<String, dynamic>.from(payload))
          : null,
      statusCode: json['status'] is int
          ? json['status'] as int
          : int.tryParse('${json['status'] ?? ''}'),
      message: message,
    );
  }
}

class MonimePaymentResult {
  final String id;
  final String mode;
  final String status;
  final String name;
  final MonimeAmount amount;
  final bool enable;
  final DateTime expireTime;
  final MonimeCustomer customer;
  final String ussdCode;
  final String reference;
  final String? authorizedPhoneNumber;
  final String? financialAccountId;
  final DateTime createTime;
  final DateTime updateTime;

  MonimePaymentResult({
    required this.id,
    required this.mode,
    required this.status,
    required this.name,
    required this.amount,
    required this.enable,
    required this.expireTime,
    required this.customer,
    required this.ussdCode,
    required this.reference,
    this.authorizedPhoneNumber,
    this.financialAccountId,
    required this.createTime,
    required this.updateTime,
  });

  factory MonimePaymentResult.fromJson(Map<String, dynamic> json) {
    return MonimePaymentResult(
      id: json['id'] ?? '',
      mode: json['mode'] ?? '',
      status: json['status'] ?? '',
      name: json['name'] ?? '',
      amount: MonimeAmount.fromJson(json['amount'] ?? {}),
      enable: json['enable'] ?? false,
      expireTime: DateTime.parse(
          json['expireTime'] ?? DateTime.now().toIso8601String()),
      customer: MonimeCustomer.fromJson(json['customer'] ?? {}),
      ussdCode: json['ussdCode'] ?? '',
      reference: json['reference'] ?? '',
      authorizedPhoneNumber: json['authorizedPhoneNumber'],
      financialAccountId: json['financialAccountId'],
      createTime: DateTime.parse(
          json['createTime'] ?? DateTime.now().toIso8601String()),
      updateTime: DateTime.parse(
          json['updateTime'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get normalizedStatus => status.trim().toLowerCase();

  bool get isSuccessful =>
      normalizedStatus == 'completed' || normalizedStatus == 'paid';

  bool get isExpired => normalizedStatus == 'expired';

  bool get isTerminal =>
      isSuccessful ||
      const {'expired', 'cancelled', 'failed'}.contains(normalizedStatus);

  Duration get remainingTime {
    final remaining = expireTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

class MonimeAmount {
  final String currency;
  final double value;

  MonimeAmount({required this.currency, required this.value});

  factory MonimeAmount.fromJson(Map<String, dynamic> json) {
    return MonimeAmount(
      currency: json['currency'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
    );
  }
}

class MonimeCustomer {
  final String name;

  MonimeCustomer({required this.name});

  factory MonimeCustomer.fromJson(Map<String, dynamic> json) {
    return MonimeCustomer(
      name: json['name'] ?? '',
    );
  }
}
