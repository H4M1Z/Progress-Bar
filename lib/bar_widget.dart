import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_assignment/linear_bar.dart';

class CenterLinearBarDesign extends StatelessWidget {
  const CenterLinearBarDesign(
      {super.key,
      required this.animationForBallPosition,
      required this.animationForBallRotation,
      required this.animationForBallSize,
      required this.ballImage,
      required this.barWidth,
      required this.barHeight});
  final double barWidth, barHeight;
  final Animation<AlignmentGeometry> animationForBallPosition;
  final Animation<double> animationForBallSize;
  final Animation<double> animationForBallRotation;
  final String ballImage;

  static const grassImage = 'assets/images/grass.jpg';

  static final containerDecoration = BoxDecoration(
      boxShadow: const [
        BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 5,
            spreadRadius: 1,
            color: Colors.black54),
        BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 5,
            spreadRadius: 1,
            color: Colors.black45),
      ],
      borderRadius: BorderRadius.circular(
        50,
      ),
      image: const DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            grassImage,
          )));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          decoration: containerDecoration,
          width: barWidth,
          height: barHeight,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // hole made by custom painter in which the ball goes in...
              Align(
                alignment: Alignment.centerRight,
                child: Hole(
                  barWidth: barWidth,
                ),
              ),
              //The Ball that moves from left to right....
              AlignTransition(
                alignment: animationForBallPosition,
                child: ScaleTransition(
                  scale: animationForBallSize,
                  child: RotationTransition(
                    turns: animationForBallRotation,
                    child: SizedBox(
                        width: barWidth * 0.07,
                        height: barHeight,
                        child: Image.asset(
                          ballImage,
                        )),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
