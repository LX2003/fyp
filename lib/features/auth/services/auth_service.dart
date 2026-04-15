import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/auth_response.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  // ── Register ──────────────────────────────────────
  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
    required String dateofbirth,
    required String fullName,
    String? contactNo,
  }) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: {
        'username': username,
        'email': email,
        'password': password,
        'dateofbirth': dateofbirth,
        'full_name': fullName,
        'contact_no': contactNo,
      },
    );

    return AuthResponse.fromJson(response.data);
  }

  // ── Login ─────────────────────────────────────────
  Future<AuthResponse> login({
    required String identifier,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {
        'identifier': identifier,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response.data);
    await _saveTokens(authResponse.accessToken, authResponse.refreshToken);
    return authResponse;
  }

  // ── Save tokens to local storage ──────────────────
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  // ── Logout ────────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }
}
