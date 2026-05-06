import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/home_controller.dart';
import '../models/bank_transaction.dart';
import '../widgets/account_card.dart';
import '../widgets/balance_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/favourite_bar.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_transaction_tile.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = HomeController();
  bool _showBalances = true;

  @override
  void initState() {
    super.initState();
    _controller.loadHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final balance = _formatMoney(_controller.account?.balance);
            final balanceText = _showBalances ? balance : '****';
            final recentTransactions = _controller.transactions.take(2).toList();
            final savingsBalance = _controller.pockets.isEmpty
                ? null
                : _controller.pockets.fold<double>(
                    0,
                    (total, pocket) => total + pocket.balance,
                  );
            final savingsText = _showBalances
                ? _formatMoney(savingsBalance)
                : '****';

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _controller.loadHome,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 96),
                children: [
                  DashboardHeader(username: _controller.username),
                  const SizedBox(height: 22),
                  BalanceCard(
                    amount: balanceText,
                    isLoading: _controller.isLoading,
                    isVisible: _showBalances,
                    onToggleVisibility: () {
                      setState(() {
                        _showBalances = !_showBalances;
                      });
                    },
                  ),
                  if (_controller.errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _controller.errorMessage!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  const QuickActions(),
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'My Accounts', actionLabel: 'View All'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AccountCard(
                          title: 'Main Account',
                          amount: 'RM $balanceText',
                          icon: Icons.account_balance_wallet_rounded,
                          accentColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AccountCard(
                          title: 'Saving Account',
                          amount: 'RM $savingsText',
                          icon: Icons.savings_rounded,
                          accentColor: const Color(0xFF22C55E),
                          badge: 'Up to 4.00% p.a.',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Top Favourite'),
                  const SizedBox(height: 10),
                  const FavouriteBar(),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    title: 'Recent Transaction',
                    actionLabel: 'View More',
                  ),
                  const SizedBox(height: 10),
                  if (recentTransactions.isEmpty)
                    const _EmptyTransactions()
                  else
                    for (final transaction in recentTransactions) ...[
                      _TransactionTileFromApi(
                        transaction: transaction,
                        accountId: _controller.account?.accountId ?? '',
                      ),
                      const SizedBox(height: 10),
                    ],
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigation(),
    );
  }

  String _formatMoney(double? value) {
    if (value == null) return '****';
    return value.toStringAsFixed(2);
  }
}

class _TransactionTileFromApi extends StatelessWidget {
  final BankTransaction transaction;
  final String accountId;

  const _TransactionTileFromApi({
    required this.transaction,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context) {
    final isDebit = transaction.isDebitFor(accountId);
    final title = transaction.description.isEmpty
        ? _titleFromType(transaction.type)
        : transaction.description;

    return RecentTransactionTile(
      title: title,
      time: _formatDate(transaction.createdAt),
      amount: '${isDebit ? '-' : '+'}RM ${transaction.amount.toStringAsFixed(2)}',
      icon: isDebit ? Icons.payments_rounded : Icons.input_rounded,
      tintColor: isDebit ? const Color(0xFFFFEEF2) : const Color(0xFFE5FBF2),
      iconColor: isDebit ? const Color(0xFFF43F5E) : const Color(0xFF10B981),
      amountColor: isDebit ? const Color(0xFFE11D48) : const Color(0xFF059669),
    );
  }

  String _titleFromType(String type) {
    switch (type) {
      case 'transfer':
        return 'Money Transfer';
      case 'deposit':
        return 'Deposit';
      case 'payment':
        return 'Payment';
      case 'interest':
        return 'Interest';
      case 'withdrawal':
        return 'Withdrawal';
      default:
        return 'Transaction';
    }
  }

  String _formatDate(DateTime date) {
    if (date.millisecondsSinceEpoch == 0) return 'Recent activity';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour == 0 || date.hour == 12 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${months[date.month - 1]} ${date.day}, ${date.year} - $hour:$minute $period';
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'No recent transactions yet',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
