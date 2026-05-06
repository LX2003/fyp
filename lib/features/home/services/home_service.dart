import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/account_summary.dart';
import '../models/bank_transaction.dart';
import '../models/savings_pocket.dart';

class HomeService {
  final Dio _dio;

  HomeService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<AccountSummary> getBalance() async {
    final response = await _dio.get(ApiConstants.accountBalance);
    return AccountSummary.fromJson(_unwrapMap(response.data));
  }

  Future<String> getUsername() async {
    final response = await _dio.get(ApiConstants.me);
    final data = _unwrapMap(response.data);
    return (data['username'] ?? 'Kent').toString();
  }

  Future<List<BankTransaction>> getHistory() async {
    final response = await _dio.get(ApiConstants.accountHistory);
    return _unwrapList(response.data)
        .whereType<Map<String, dynamic>>()
        .map(BankTransaction.fromJson)
        .toList();
  }

  Future<List<SavingsPocket>> getPockets() async {
    final response = await _dio.get(ApiConstants.accountPockets);
    return _unwrapList(response.data)
        .whereType<Map<String, dynamic>>()
        .map(SavingsPocket.fromJson)
        .toList();
  }

  Map<String, dynamic> _unwrapMap(dynamic responseData) {
    final data = responseData is Map<String, dynamic>
        ? responseData['data'] ?? responseData
        : <String, dynamic>{};

    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  List<dynamic> _unwrapList(dynamic responseData) {
    final data = responseData is Map<String, dynamic>
        ? responseData['data'] ?? const []
        : const [];

    return data is List ? data : const [];
  }
}
