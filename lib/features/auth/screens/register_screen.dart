import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = RegisterController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _controller.register();

    if (!mounted) return;
    if (success) {
      // TODO: Navigator.pushReplacementNamed(context, AppRoutes.home);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Please try again.')),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _controller.dobController.text =
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Account',
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
                    const SizedBox(height: 16),

                    // ── Hero Section ───────────────────────────────
                    Center(child: _buildHeroIllustration()),
                    const SizedBox(height: 20),

                    const Center(
                      child: Text('Join us today', style: AppTextStyles.heading),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Create your account to get started with our platform.',
                        style: AppTextStyles.subtitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Full Name ──────────────────────────────────
                    _buildLabel('FULL NAME'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _controller.fullNameController,
                      hintText: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Please enter your full name' : null,
                    ),
                    const SizedBox(height: 16),

                    // ── Username ───────────────────────────────────
                    _buildLabel('USERNAME'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _controller.usernameController,
                      hintText: 'Choose a unique username',
                      prefixIcon: Icons.alternate_email,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please enter a username';
                        if (v.length < 3) return 'Username must be at least 3 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Email ──────────────────────────────────────
                    _buildLabel('EMAIL ADDRESS'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _controller.emailController,
                      hintText: 'example@email.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please enter your email';
                        if (!v.contains('@')) return 'Please enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Phone ──────────────────────────────────────
                    _buildLabel('PHONE NUMBER'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _controller.phoneController,
                      hintText: '+60 12-345-6789',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Please enter your phone number' : null,
                    ),
                    const SizedBox(height: 16),

                    // ── Date of Birth ──────────────────────────────
                    _buildLabel('DATE OF BIRTH'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _controller.dobController,
                          hintText: 'mm/dd/yyyy',
                          prefixIcon: Icons.calendar_today_outlined,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Please select your date of birth' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Password ───────────────────────────────────
                    _buildLabel('PASSWORD'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _controller.passwordController,
                      hintText: 'Password',
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
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please enter a password';
                        if (v.length < 8 || v.length > 20) return 'Password must be between 8 and 16 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Confirm Password ───────────────────────────
                    _buildLabel('CONFIRM'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _controller.confirmPasswordController,
                      hintText: 'Confirm password',
                      prefixIcon: Icons.lock_reset_outlined,
                      obscureText: _controller.obscureConfirm,
                      suffixIcon: GestureDetector(
                        onTap: _controller.toggleConfirmVisibility,
                        child: Icon(
                          _controller.obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please confirm your password';
                        if (v != _controller.passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // ── Sign Up Button ─────────────────────────────
                    PrimaryButton(
                      text: 'Sign Up',
                      icon: Icons.rocket_launch_outlined,
                      onPressed: _handleRegister,
                      isLoading: _controller.isLoading,
                    ),
                    const SizedBox(height: 24),

                    // ── Login Link ─────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Already have an account?',
                            style: AppTextStyles.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 10,
                              ),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildHeroIllustration() {
    return SizedBox(
      width: 120,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background blob
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          // Avatar circle
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.face_outlined,
              color: AppColors.primary,
              size: 38,
            ),
          ),
          // Small sparkle badge
          Positioned(
            bottom: 0,
            right: 8,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppColors.primary,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}