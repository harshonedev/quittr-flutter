import 'dart:math';

import 'package:flutter/material.dart';

class BreathingPathPainter extends CustomPainter {
  final double progress;

  BreathingPathPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    /* Same painting logic as original */

    final paint = Paint()
      ..strokeWidth = 60
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final ballPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    final path = Path();

    // Calculate points for 110-degree angles
    final startX = 0.0; // Start from the left edge
    final endX = size.width; // End at the right edge
    final startY = size.height * 0.8;
    final topY = size.height * 0.2;

    // Calculate the horizontal distance for the top line
    // Using trigonometry to maintain 110-degree angles
    final angle = (115 - 90) * pi / 180; // Convert to radians
    final horizontalOffset = (startY - topY) * tan(angle);

    // Calculate the three main points
    final p1 = Offset(startX, startY);
    final p2 = Offset(startX + horizontalOffset, topY);
    final p3 = Offset(endX - horizontalOffset, topY);
    final p4 = Offset(endX, startY);

    // Draw the path
    path.moveTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p3.dx, p3.dy);
    path.lineTo(p4.dx, p4.dy);

    canvas.drawPath(path, paint);

    // Calculate ball position
    Offset ballPosition;
    //final pathLength = p2.dx - p1.dx; // Length of first segment
    //final holdLength = p3.dx - p2.dx; // Length of holding segment
    //final downLength = p4.dx - p3.dx; // Length of last segment

    if (progress < 1 / 3) {
      // Going up
      double normalizedProgress = progress * 3;
      ballPosition = Offset(
        lerp(p1.dx, p2.dx, normalizedProgress),
        lerp(p1.dy, p2.dy, normalizedProgress),
      );
    } else if (progress < 2 / 3) {
      // Moving horizontally
      double normalizedProgress = (progress - 1 / 3) * 3;
      ballPosition = Offset(lerp(p2.dx, p3.dx, normalizedProgress), p2.dy);
    } else {
      // Going down
      double normalizedProgress = (progress - 2 / 3) * 3;
      ballPosition = Offset(
        lerp(p3.dx, p4.dx, normalizedProgress),
        lerp(p3.dy, p4.dy, normalizedProgress),
      );
    }

    // Draw the ball
    canvas.drawCircle(ballPosition, 12, ballPaint);
  }

  double lerp(double start, double end, double progress) {
    return start + (end - start) * progress;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}