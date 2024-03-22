import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_assignment/circular_bar.dart';
import 'package:flutter_progress_bar_assignment/movement_transition.dart';
import 'package:flutter_progress_bar_assignment/numbers_transition.dart';

class CircularProgressBar extends StatefulWidget {
  const CircularProgressBar({
    super.key,
    required this.duration,
    this.textColor,
    this.outerBarColor,
    this.innerBarColor,
    this.curve,
    this.textSize,
    this.ballImage,
  });
  final Duration duration;
  final Color? textColor, outerBarColor, innerBarColor;
  final double? textSize;

  final String? ballImage;
  final Curve? curve;
  @override
  State<CircularProgressBar> createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar>
    with SingleTickerProviderStateMixin {
  //controllers
  late AnimationController _animationController;

  //animations
  late Animation<double> _animationForRotatingBall;
  late Animation<double> _animationForBallPosition;
  late Animation<double> _animationForRotatingBallOpacity;
  late Animation<double> _animationForMovingBallOpacity;
  late Animation<int> _animationForPercentage;

  //Tweens
  final tweenForgolfBallRotation = Tween<double>(begin: 0.075, end: 1.0);
  final tweenForRotatingBallOpacity = Tween<double>(begin: 0.0, end: 1.0);
  final tweenForMovingBallOpacity = Tween<double>(begin: 1.0, end: 0.0);
  final tweenForLoadingLine = Tween<double>(begin: 0.0, end: 200.5);
  final tweenForPercentage = IntTween(begin: 0, end: 100);

  static const golfGrassImage = 'assets/images/golfgrass.png';
  static const completed = 'Completed';
  static late final TextStyle completedStyle;
  static late final Container golfContainer;
  static late final Size defaultBarSize;
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

    defaultBarSize = Size(MediaQuery.sizeOf(context).width * 0.3,
        MediaQuery.sizeOf(context).height * 0.2);

    golfContainer = Container(
      alignment: Alignment.topRight,
      width: MediaQuery.sizeOf(context).width * 0.05,
      height: MediaQuery.sizeOf(context).height * 0.25,
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
    _animationForBallPosition = Tween<double>(
            begin: MediaQuery.sizeOf(context).width * 0.5,
            end: MediaQuery.sizeOf(context).width * 0.55)
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
    return SizedBox.expand(
        child: Stack(
      alignment: Alignment.center,
      children: [
        //Bar
        SizedBox(
          width: defaultBarSize.width,
          height: defaultBarSize.height,
          child: CircularBar(
            duration: widget.duration,
            outerBarColor: widget.outerBarColor,
            innerBarColor: widget.innerBarColor,
            curve: widget.curve,
          ),
        ),
        //Grass image
        Positioned(
          top: MediaQuery.sizeOf(context).height * 0.33,
          child: SizedBox(
            width: defaultBarSize.width,
            height: defaultBarSize.height,
            child: Image.asset(
              golfGrassImage,
              fit: BoxFit.fill,
            ),
          ),
        ),
        // Rotating ball
        FadeTransition(
          opacity: _animationForRotatingBallOpacity,
          child: RotationTransition(
            turns: _animationForRotatingBall,
            child: golfContainer,
          ),
        ),
        //Moving ball (Made a Seperate moving Transition as there is no built-in Widget available for it and also to improve performance by not refreshing the whole widget)
        MovementTransition(
          shouldMoveleft: true,
          animation: _animationForBallPosition,
          child: FadeTransition(
            opacity: _animationForMovingBallOpacity,
            child: golfContainer,
          ),
        ),
        // Current State
        Positioned(
          top: MediaQuery.sizeOf(context).height * 0.51,
          child: AnimatedCrossFade(
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
          ),
        )
      ],
    ));
  }
}
