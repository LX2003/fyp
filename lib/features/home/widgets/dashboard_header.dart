import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  final String username;

  const DashboardHeader({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFF8D9E8),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Hi $username',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const _HeaderIconButton(icon: Icons.notifications_none_rounded),
        SizedBox(width: 10),
        const _HeaderIconButton(icon: Icons.logout_rounded),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;

  const _HeaderIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.textSecondary, size: 18),
    );
  }
}
