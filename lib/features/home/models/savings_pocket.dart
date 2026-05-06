class SavingsPocket {
  final String pocketId;
  final String name;
  final double balance;
  final double targetAmount;

  const SavingsPocket({
    required this.pocketId,
    required this.name,
    required this.balance,
    required this.targetAmount,
  });

  factory SavingsPocket.fromJson(Map<String, dynamic> json) {
    return SavingsPocket(
      pocketId: (json['pocket_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Saving Account').toString(),
      balance: _toDouble(json['balance']),
      targetAmount: _toDouble(json['target_amount']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
