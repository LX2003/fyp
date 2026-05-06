import 'package:flutter/material.dart';

import '../models/account_summary.dart';
import '../models/bank_transaction.dart';
import '../models/savings_pocket.dart';
import '../services/home_service.dart';

class HomeController extends ChangeNotifier {
  final HomeService _homeService;

  HomeController({HomeService? homeService})
      : _homeService = homeService ?? HomeService();

  bool _isLoading = false;
  String? _errorMessage;
  AccountSummary? _account;
  List<BankTransaction> _transactions = [];
  List<SavingsPocket> _pockets = [];
  String _username = 'Kent';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AccountSummary? get account => _account;
  List<BankTransaction> get transactions => _transactions;
  List<SavingsPocket> get pockets => _pockets;
  String get username => _username;

  Future<void> loadHome() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _homeService.getUsername(),
        _homeService.getBalance(),
        _homeService.getHistory(),
        _homeService.getPockets(),
      ]);

      _username = results[0] as String;
      _account = results[1] as AccountSummary;
      _transactions = results[2] as List<BankTransaction>;
      _pockets = results[3] as List<SavingsPocket>;
    } catch (e) {
      _errorMessage = 'Unable to load account data. Pull down to try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
