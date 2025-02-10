import 'package:flutter/cupertino.dart';

class CurvePainterRegister extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0XFFACD0C1) // Color for the first curve
      ..style = PaintingStyle.fill;


    // First Curve
    final path1 = Path();

    const startPoint1 = Offset(0, 40);
    final endPoint1 = Offset(size.width, 30);

    final controlPoint1_1 = Offset(size.width * 0.35, size.height * 0.05);
    final controlPoint1_2 = Offset(size.width * 0.55, size.height * 0.25);

    path1.moveTo(startPoint1.dx, startPoint1.dy);
    path1.cubicTo(
      controlPoint1_1.dx,
      controlPoint1_1.dy,
      controlPoint1_2.dx,
      controlPoint1_2.dy,
      endPoint1.dx,
      endPoint1.dy,
    );
    path1.lineTo(size.width, 0);
    path1.lineTo(0, 0);
    path1.close();

    canvas.drawPath(path1, paint1);


    // Second Curve
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}