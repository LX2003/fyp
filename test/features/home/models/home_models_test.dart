import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/home/models/account_summary.dart';
import 'package:my_flutter_app/features/home/models/bank_transaction.dart';

void main() {
  group('AccountSummary.fromJson', () {
    test('parses balance response data from backend', () {
      final account = AccountSummary.fromJson({
        'account_id': 'account-1',
        'account_number': 123456789,
        'balance': 250.75,
      });

      expect(account.accountId, 'account-1');
      expect(account.accountNumber, '123456789');
      expect(account.balance, 250.75);
    });
  });

  group('BankTransaction.fromJson', () {
    test('parses transaction history row from backend', () {
      final transaction = BankTransaction.fromJson({
        'transaction_id': 'tx-1',
        'amount': 100,
        'transaction_type': 'transfer',
        'transaction_status': 'completed',
        'description': 'Money Transfer',
        'created_at': '2026-05-05T10:30:45.034Z',
        'sender_account_id': 'account-1',
        'receiver_account_id': 'account-2',
      });

      expect(transaction.transactionId, 'tx-1');
      expect(transaction.amount, 100);
      expect(transaction.type, 'transfer');
      expect(transaction.status, 'completed');
      expect(transaction.description, 'Money Transfer');
      expect(transaction.createdAt.year, 2026);
    });
  });
}
