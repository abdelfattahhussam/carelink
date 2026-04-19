import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom CareLink logo built entirely with Flutter widgets.
/// Combines a medical cross with a connection/link motif.
class CareLinkLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const CareLinkLogo({
    super.key,
    this.size = 100,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? Colors.white;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CareLinkLogoPainter(color: logoColor),
      ),
    );
  }
}

class _CareLinkLogoPainter extends CustomPainter {
  final Color color;

  _CareLinkLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final unit = size.width / 10;

    // ── Outer ring (connection motif) ──
    final ringPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = unit * 0.4
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, unit * 4.2, ringPaint);

    // ── Link dots on ring (4 connection nodes) ──
    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) - math.pi / 4;
      final dx = center.dx + math.cos(angle) * unit * 4.2;
      final dy = center.dy + math.sin(angle) * unit * 4.2;
      canvas.drawCircle(Offset(dx, dy), unit * 0.35, dotPaint);
    }

    // ── Inner glow circle ──
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, unit * 3.2, glowPaint);

    // ── Medical cross ──
    final crossPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final crossWidth = unit * 1.6;
    final crossLength = unit * 4.8;

    // Vertical bar
    final verticalRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: crossWidth,
        height: crossLength,
      ),
      Radius.circular(crossWidth / 2),
    );
    canvas.drawRRect(verticalRect, crossPaint);

    // Horizontal bar
    final horizontalRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: crossLength,
        height: crossWidth,
      ),
      Radius.circular(crossWidth / 2),
    );
    canvas.drawRRect(horizontalRect, crossPaint);

    // ── Heart accent at center-bottom of cross ──
    final heartSize = unit * 1.0;
    final heartCenter = Offset(center.dx, center.dy + unit * 0.1);
    final heartPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final heartPath = Path();
    heartPath.moveTo(heartCenter.dx, heartCenter.dy + heartSize * 0.6);
    heartPath.cubicTo(
      heartCenter.dx - heartSize,
      heartCenter.dy - heartSize * 0.2,
      heartCenter.dx - heartSize * 0.5,
      heartCenter.dy - heartSize * 0.9,
      heartCenter.dx,
      heartCenter.dy - heartSize * 0.3,
    );
    heartPath.cubicTo(
      heartCenter.dx + heartSize * 0.5,
      heartCenter.dy - heartSize * 0.9,
      heartCenter.dx + heartSize,
      heartCenter.dy - heartSize * 0.2,
      heartCenter.dx,
      heartCenter.dy + heartSize * 0.6,
    );
    canvas.drawPath(heartPath, heartPaint);
  }

  @override
  bool shouldRepaint(covariant _CareLinkLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}
