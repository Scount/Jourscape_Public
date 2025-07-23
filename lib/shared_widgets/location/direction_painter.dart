import 'dart:math';

import 'package:flutter/material.dart';

class DirectionConePainter extends CustomPainter {
  final Color color;
  final Color lineColor;
  final double circleRadius;
  final Color triangleColor;
  DirectionConePainter({
    this.color = Colors.blue,
    this.lineColor = Colors.red,
    this.circleRadius = 15.0,
    this.triangleColor = Colors.red,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double circumference = 2 * pi * circleRadius;
    final double lineLength = 0.2 * circumference;

    final double sweepAngle = lineLength / circleRadius;

    final Rect arcRect = Rect.fromCircle(
      center: Offset(centerX, centerY),
      radius: circleRadius,
    );

    canvas.drawArc(arcRect, -pi / 2, sweepAngle, false, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
