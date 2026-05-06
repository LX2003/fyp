class BankTransaction {
  final String transactionId;
  final double amount;
  final String type;
  final String status;
  final String description;
  final DateTime createdAt;
  final String senderAccountId;
  final String receiverAccountId;

  const BankTransaction({
    required this.transactionId,
    required this.amount,
    required this.type,
    required this.status,
    required this.description,
    required this.createdAt,
    required this.senderAccountId,
    required this.receiverAccountId,
  });

  factory BankTransaction.fromJson(Map<String, dynamic> json) {
    return BankTransaction(
      transactionId: (json['transaction_id'] ?? '').toString(),
      amount: _toDouble(json['amount']),
      type: (json['transaction_type'] ?? '').toString(),
      status: (json['transaction_status'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      senderAccountId: (json['sender_account_id'] ?? '').toString(),
      receiverAccountId: (json['receiver_account_id'] ?? '').toString(),
    );
  }

  bool isDebitFor(String accountId) => senderAccountId == accountId;

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
