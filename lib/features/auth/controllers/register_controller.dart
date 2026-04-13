// lib/features/auth/controllers/register_controller.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterController extends ChangeNotifier {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirm => _obscureConfirm;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  Future<bool> register() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        dateofbirth: _formatDate(dobController.text),
        fullName: fullNameController.text.trim(),
        contactNo: phoneController.text.trim(),
      );
      return true;
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] is List
          ? (e.response?.data['message'] as List).first
          : e.response?.data['message'] ?? 'Registration failed. Try again.';
      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong. Try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Convert mm/dd/yyyy → yyyy-MM-dd (ISO format for backend)
  String _formatDate(String date) {
    try {
      final parts = date.split('/');
      return '${parts[2]}-${parts[0].padLeft(2, '0')}-${parts[1].padLeft(2, '0')}';
    } catch (_) {
      return date;
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}