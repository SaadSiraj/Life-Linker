import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';

class HeartRateChartPainter extends CustomPainter {
  final List<double> points;

  const HeartRateChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final double minVal = points.reduce((a, b) => a < b ? a : b) - 5;
    final double maxVal = points.reduce((a, b) => a > b ? a : b) + 5;
    final double range = maxVal - minVal;

    double normalize(double v) => (v - minVal) / range;

    final List<Offset> offsets = List.generate(points.length, (i) {
      final dx = (i / (points.length - 1)) * size.width;
      final dy = size.height - normalize(points[i]) * size.height;
      return Offset(dx, dy);
    });

    // Fill gradient
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    for (final o in offsets) {
      fillPath.lineTo(o.dx, o.dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.success.withOpacity(0.3),
          AppColors.success.withOpacity(0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path();
    linePath.moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 1; i < offsets.length; i++) {
      final prev = offsets[i - 1];
      final curr = offsets[i];
      final cpx = (prev.dx + curr.dx) / 2;
      linePath.cubicTo(cpx, prev.dy, cpx, curr.dy, curr.dx, curr.dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Current dot
    final dotPaint = Paint()..color = AppColors.success;
    canvas.drawCircle(offsets.last, 4, dotPaint);
    final dotBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(offsets.last, 4, dotBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}