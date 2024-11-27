import 'package:flutter/material.dart';

class CircleBorderPainter extends CustomPainter {
  final int pageNumber;

  CircleBorderPainter(this.pageNumber);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF1877F2)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final Paint lightPaint = Paint()
      ..color = const Color(0xFF1877F2).withOpacity(0.3)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    double startAngle = -3.141592653589793 / 2;
    double sweepAngle = (2 * 3.141592653589793) * (pageNumber + 1) / 3;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

    canvas.drawArc(rect, startAngle + sweepAngle,
        2 * 3.141592653589793 - sweepAngle, false, lightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
