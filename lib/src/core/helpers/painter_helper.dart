import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  final Color color;
  final bool isLeft;

  TrianglePainter({required this.color, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();

    if (isLeft) {
      path
        ..moveTo(0, size.height)
        ..lineTo(size.width, size.height * 0.7)
        ..lineTo(size.width, size.height);
    } else {
      path
        ..moveTo(size.width, size.height)
        ..lineTo(0, size.height * 0.7)
        ..lineTo(0, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
