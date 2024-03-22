import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressBarPainter extends CustomPainter {
  final Color? outerbarColor, innerBarColor;
  final double barAngle;
  const CircularProgressBarPainter(
      {this.outerbarColor, this.innerBarColor, required this.barAngle});
  @override
  void paint(Canvas canvas, Size size) {
    final Size(:width, :height) = size;
    final radius = min(width, height) / 2;
    final centerOffset = Offset(width * 0.5, height * 0.5);
    final mainRectangle = Rect.fromLTWH(0, 0, width, height);

    //Paints
    final outerbarPaint = Paint()
      ..color = outerbarColor ?? Colors.brown.shade300
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeWidth = width * 0.25;
    final whitePaint = Paint()..color = Colors.white;
    final innerBarPaint = Paint()
      ..color = innerBarColor ?? Colors.brown.shade500
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width * 0.2;

    //progress bar circle
    canvas.drawArc(
        mainRectangle, degTorRad(350), degTorRad(200.5), true, outerbarPaint);
    //inner loading line
    canvas.drawArc(mainRectangle, degTorRad(350), degTorRad(barAngle), true,
        innerBarPaint);
    //center circle
    canvas.drawCircle(centerOffset, radius, whitePaint);
  }

  double degTorRad(double deg) => deg * pi / 180;

  @override
  bool shouldRepaint(CircularProgressBarPainter oldDelegate) =>
      oldDelegate.barAngle != barAngle;

  @override
  bool shouldRebuildSemantics(CircularProgressBarPainter oldDelegate) =>
      oldDelegate.barAngle != barAngle;
}

class HolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Size(:width, :height) = size;
    final radius = min(width, height) / 2;
    final centerOffset = Offset(width * 0.5, height * 0.5);

    //Paints
    final lightBrownPaint = Paint()..color = Colors.brown.shade500;
    final darkBrownPaint = Paint()..color = Colors.brown.shade700;

    //light brown circle
    canvas.drawCircle(centerOffset, radius, lightBrownPaint);
    //dark brown circle
    canvas.drawCircle(centerOffset, radius * 0.8, darkBrownPaint);
  }

  @override
  bool shouldRepaint(HolePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(HolePainter oldDelegate) => false;
}
