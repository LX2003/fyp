class AccountSummary {
  final String accountId;
  final String accountNumber;
  final double balance;

  const AccountSummary({
    required this.accountId,
    required this.accountNumber,
    required this.balance,
  });

  factory AccountSummary.fromJson(Map<String, dynamic> json) {
    return AccountSummary(
      accountId: (json['account_id'] ?? '').toString(),
      accountNumber: (json['account_number'] ?? '').toString(),
      balance: _toDouble(json['balance']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
