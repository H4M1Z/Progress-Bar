import 'package:flutter/material.dart';

class MovingBall extends StatelessWidget {
  const MovingBall(
      {super.key,
      required this.size,
      this.backGroundImage = 'assets/images/golfgrass.png',
      this.ballImage = 'assets/images/golfball.png',
      required this.animationForBallOpacity,
      required this.animationForBallPosition});
  final Size size;
  final String? backGroundImage, ballImage;
  final Animation<double> animationForBallOpacity;
  final Animation<AlignmentGeometry> animationForBallPosition;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height * 0.55,
            child: Image.asset(
              backGroundImage!,
              fit: BoxFit.fill,
            ),
          ),
          // move the ball to the right and then disappear it...
          AlignTransition(
            alignment: animationForBallPosition,
            child: FadeTransition(
              opacity: animationForBallOpacity,
              child: SizedBox(
                width: size.width * 0.15,
                height: size.height * 0.3,
                child: Image.asset(ballImage!),
              ),
            ),
          )
        ],
      ),
    );
  }
}
