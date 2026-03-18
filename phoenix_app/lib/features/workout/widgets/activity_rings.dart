import 'dart:math';
import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';

/// Three concentric activity rings (Apple Watch style) with Phoenix colors.
class ActivityRings extends StatelessWidget {
  final double trainingProgress;
  final double fastingProgress;
  final double conditioningProgress;
  final double size;

  const ActivityRings({
    super.key,
    required this.trainingProgress,
    required this.fastingProgress,
    required this.conditioningProgress,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: AnimDurations.ringFill,
        curve: Curves.easeOutCubic,
        builder: (context, animValue, _) {
          return CustomPaint(
            painter: _ActivityRingsPainter(
              trainingProgress: trainingProgress * animValue,
              fastingProgress: fastingProgress * animValue,
              conditioningProgress: conditioningProgress * animValue,
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
          );
        },
      ),
    );
  }
}

class _ActivityRingsPainter extends CustomPainter {
  final double trainingProgress;
  final double fastingProgress;
  final double conditioningProgress;
  final bool isDark;

  _ActivityRingsPainter({
    required this.trainingProgress,
    required this.fastingProgress,
    required this.conditioningProgress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    const strokeOuter = 16.0;
    const strokeMiddle = 14.0;
    const strokeInner = 12.0;
    const gap = 4.0;

    final outerRadius = maxRadius - strokeOuter / 2;
    final middleRadius = outerRadius - strokeOuter / 2 - gap - strokeMiddle / 2;
    final innerRadius = middleRadius - strokeMiddle / 2 - gap - strokeInner / 2;

    final bgAlpha = isDark ? 40 : 30;

    // Draw ring backgrounds
    _drawRingBg(canvas, center, outerRadius, strokeOuter,
        PhoenixColors.trainingAccent.withAlpha(bgAlpha));
    _drawRingBg(canvas, center, middleRadius, strokeMiddle,
        PhoenixColors.fastingAccent.withAlpha(bgAlpha));
    _drawRingBg(canvas, center, innerRadius, strokeInner,
        PhoenixColors.conditioningAccent.withAlpha(bgAlpha));

    // Draw ring progress
    _drawRingProgress(canvas, center, outerRadius, strokeOuter,
        PhoenixColors.trainingAccent, trainingProgress);
    _drawRingProgress(canvas, center, middleRadius, strokeMiddle,
        PhoenixColors.fastingAccent, fastingProgress);
    _drawRingProgress(canvas, center, innerRadius, strokeInner,
        PhoenixColors.conditioningAccent, conditioningProgress);
  }

  void _drawRingBg(
      Canvas canvas, Offset center, double radius, double stroke, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);
  }

  void _drawRingProgress(Canvas canvas, Offset center, double radius,
      double stroke, Color color, double progress) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);
    const startAngle = -pi / 2; // 12 o'clock

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ActivityRingsPainter oldDelegate) {
    return trainingProgress != oldDelegate.trainingProgress ||
        fastingProgress != oldDelegate.fastingProgress ||
        conditioningProgress != oldDelegate.conditioningProgress;
  }
}
