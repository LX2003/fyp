import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controllers/login_controller.dart';
import '../../../app/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = LoginController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _controller.login();

    if (!mounted) return;
    if (success) {
      // TODO: Navigate to home
      // Navigator.pushReplacementNamed(context, AppRoutes.home);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // ── Logo ──────────────────────────────────────
                    Center(child: _buildLogoIcon()),
                    const SizedBox(height: 24),

                    // ── Heading ───────────────────────────────────
                    const Center(
                      child: Text('Welcome Back', style: AppTextStyles.heading),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Please sign in to continue your journey',
                        style: AppTextStyles.subtitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // ── Email Field ───────────────────────────────
                    const Text('Email or Username', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _controller.emailController,
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // ── Password Field ────────────────────────────
                    const Text('Password', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _controller.passwordController,
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _controller.obscurePassword,
                      suffixIcon: GestureDetector(
                        onTap: _controller.togglePasswordVisibility,
                        child: Icon(
                          _controller.obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Remember Me + Forgot Password ─────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _controller.rememberMe,
                                onChanged: _controller.toggleRememberMe,
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: const BorderSide(
                                  color: AppColors.border,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Remember me',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: Navigate to forgot password
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: AppTextStyles.linkText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ── Login Button ──────────────────────────────
                    PrimaryButton(
                      text: 'Login',
                      icon: Icons.login_rounded,
                      onPressed: _handleLogin,
                      isLoading: _controller.isLoading,
                    ),
                    const SizedBox(height: 40),

                    // ── Register Link ─────────────────────────────
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: AppTextStyles.bodySmall,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                              // TODO: Navigate to register
                            child: const Text(
                              'Register now',
                              style: AppTextStyles.linkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogoIcon() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.auto_awesome, color: AppColors.primary, size: 34),
      ),
    );
  }
}