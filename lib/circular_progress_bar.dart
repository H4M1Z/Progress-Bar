import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_assignment/circular_bar.dart';
import 'package:flutter_progress_bar_assignment/grass_image_widget.dart';
import 'package:flutter_progress_bar_assignment/numbers_transition.dart';

class CircularProgressBar extends StatefulWidget {
  const CircularProgressBar(
      {super.key,
      required this.duration,
      this.textColor,
      this.outerBarColor,
      this.innerBarColor,
      this.curve,
      this.textSize,
      this.ballImage,
      required this.size});
  final Duration duration;
  final Color? textColor, outerBarColor, innerBarColor;
  final double? textSize;
  final String? ballImage;
  final Curve? curve;
  final Size size;
  @override
  State<CircularProgressBar> createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar>
    with SingleTickerProviderStateMixin {
  //controllers
  late AnimationController _animationController;

  //animations
  late Animation<double> _animationForRotatingBall;
  late Animation<AlignmentGeometry> _animationForBallPosition;
  late Animation<double> _animationForRotatingBallOpacity;
  late Animation<double> _animationForMovingBallOpacity;
  late Animation<int> _animationForPercentage;

  //Tweens
  final tweenForgolfBallRotation = Tween<double>(begin: 0.075, end: 1.0);
  final tweenForRotatingBallOpacity = Tween<double>(begin: 0.0, end: 1.0);
  final tweenForMovingBallOpacity = Tween<double>(begin: 1.0, end: 0.0);
  final tweenForLoadingLine = Tween<double>(begin: 0.0, end: 200.5);
  final tweenForPercentage = IntTween(begin: 0, end: 100);

  static const completed = 'Completed';
  static late final TextStyle completedStyle;
  static late final Container golfContainer;
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration)
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                _crossFadeState = CrossFadeState.showSecond;
              });
            }
          })
          ..repeat();
    //animation Objects
    _animationForRotatingBall = tweenForgolfBallRotation.animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.3, 1.0, curve: widget.curve!)));
    _animationForRotatingBallOpacity = tweenForRotatingBallOpacity.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.3,
          0.33,
        ),
      ),
    );
    _animationForMovingBallOpacity =
        tweenForMovingBallOpacity.animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.3,
        0.33,
      ),
    ));
    _animationForPercentage = tweenForPercentage.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.34, 0.9473, curve: widget.curve!),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    golfContainer = Container(
      alignment: Alignment.topRight,
      width: widget.size.width * 0.15,
      height: widget.size.height, //0.25  0.33
      color: Colors.transparent,
      child: RotationTransition(
          turns: _animationForRotatingBall,
          child: Image.asset(widget.ballImage!)),
    );
    completedStyle = TextStyle(
        color: widget.textColor ?? Colors.black,
        fontSize: widget.textSize ?? MediaQuery.sizeOf(context).width * 0.035,
        fontWeight: FontWeight.bold);
    //animation Objects
    _animationForBallPosition = Tween<AlignmentGeometry>(
            begin: Alignment.topCenter, end: Alignment.topRight)
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            //Bar
            CircularBar(
              duration: widget.duration,
              outerBarColor: widget.outerBarColor,
              innerBarColor: widget.innerBarColor,
              curve: widget.curve,
              size: widget.size,
            ),
            //Grass image
            MovingBall(
                size: widget.size,
                animationForBallOpacity: _animationForMovingBallOpacity,
                animationForBallPosition: _animationForBallPosition),
            // Rotating  ball
            FadeTransition(
              opacity: _animationForRotatingBallOpacity,
              child: RotationTransition(
                turns: _animationForRotatingBall,
                child: golfContainer,
              ),
            ),
            // Current State
            AnimatedCrossFade(
              // (Made a number transition widget for generating numbers and for improving performance. There is also no built-in widget for this)
              firstChild: NumbersTransition(
                animation: _animationForPercentage,
                textColor: widget.textColor,
                textSize: widget.textSize,
              ),
              secondChild: Text(
                completed,
                style: completedStyle,
              ),
              crossFadeState: _crossFadeState,
              duration: const Duration(milliseconds: 300),
            )
          ],
        ));
  }
}
