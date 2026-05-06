import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class FavouriteBar extends StatelessWidget {
  const FavouriteBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFE8D8FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _FavouriteSlot(),
          _FavouriteSlot(),
          _FavouriteSlot(),
          _FavouriteSlot(),
        ],
      ),
    );
  }
}

class _FavouriteSlot extends StatelessWidget {
  const _FavouriteSlot();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedCirclePainter(),
      child: const SizedBox(
        width: 44,
        height: 44,
        child: Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFA78BFA)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    const dashCount = 18;
    const gapRadians = 0.12;
    final radius = size.width / 2 - 1;
    final center = Offset(size.width / 2, size.height / 2);
    final sweep = (6.28318530718 / dashCount) - gapRadians;

    for (var i = 0; i < dashCount; i++) {
      final start = i * 6.28318530718 / dashCount;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
