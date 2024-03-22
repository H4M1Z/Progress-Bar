import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_assignment/bar_widget.dart';
import 'package:flutter_progress_bar_assignment/loading_widget.dart';

class LinearProgressBar extends StatefulWidget {
  const LinearProgressBar(
      {super.key,
      required this.duration,
      required this.barWidth,
      this.ballImage,
      this.curve,
      this.icon,
      this.iconSize,
      this.textColor,
      this.textSize});
  final Duration duration;
  final String? ballImage;
  final IconData? icon;
  final Color? textColor;
  final double? textSize, iconSize;
  final double barWidth;
  final Curve? curve;

  @override
  State<LinearProgressBar> createState() => _LinearProgressBarState();
}

class _LinearProgressBarState extends State<LinearProgressBar>
    with TickerProviderStateMixin {
  //Controllers
  late AnimationController _animationController;
  late AnimationController _animationControllerForGolfBallSize;
  late AnimationController _animationControllerForLoadingOpacity;
  //Animations
  late Animation<double> _animationForBallRotation;
  late Animation<AlignmentGeometry> _animationForPositions;
  late Animation<double> _animationForBallSize;
  late Animation<double> _animationForTextOpacity;
  late Animation<int> _animationForPercentage;
  //Tweens
  final tweenForGolfBallRotation = Tween<double>(begin: 0.0, end: 1.0);
  final tweenForGolfBallSizeAndLoadingOpacity =
      Tween<double>(begin: 1.0, end: 0.0);
  final tweenForPercentage = IntTween(begin: 0, end: 100);
  final tweenForPositions = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft, end: Alignment.centerRight);

  String currentState = 'Loading...';

  static late final TextStyle loadingStyle;
  static late final double barHeight;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: widget.duration)
          ..forward()
          ..addStatusListener((status) {
            // call the function when animation completes
            onAnimationCompleted(status);
          });
    _animationControllerForGolfBallSize = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    )..addStatusListener((status) {
        // reapeat the animation
        repeatAnimation(status);
      });
    _animationControllerForLoadingOpacity = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationControllerForLoadingOpacity.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationControllerForLoadingOpacity.forward();
        }
      })
      ..forward();
    // animation objects
    _animationForBallRotation =
        tweenForGolfBallRotation.animate(_animationController);
    _animationForBallSize = tweenForGolfBallSizeAndLoadingOpacity
        .animate(_animationControllerForGolfBallSize);
    _animationForTextOpacity = tweenForGolfBallSizeAndLoadingOpacity
        .animate(_animationControllerForLoadingOpacity);
    _animationForPercentage = tweenForPercentage.animate(
        CurvedAnimation(parent: _animationController, curve: widget.curve!));
    _animationForPositions = Tween<AlignmentGeometry>(
            begin: Alignment.centerLeft, end: Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController, curve: widget.curve!));

    loadingStyle = TextStyle(
        color: widget.textColor ?? Colors.black,
        fontSize: widget.textSize ?? 18,
        fontWeight: FontWeight.bold);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //The context can't be inherited when we use MediaQuery in init state so I'm initializing the height here...
    barHeight = MediaQuery.sizeOf(context).height * 0.04;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationControllerForGolfBallSize.dispose();
    _animationControllerForLoadingOpacity.dispose();
    super.dispose();
  }

  void onAnimationCompleted(AnimationStatus status) {
    //decrease the size of the ball and opacity of loading....
    if (status == AnimationStatus.completed) {
      _animationControllerForGolfBallSize.forward();
      _animationControllerForLoadingOpacity.reverse();
      setState(() {
        // change the text to be displayed
        currentState = 'Completed';
      });
      //stop the animation for opacity when the loading is completed
      _animationControllerForLoadingOpacity.addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _animationControllerForLoadingOpacity.stop();
        }
      });
    }
  }

  void repeatAnimation(AnimationStatus status) {
    // for repetition bring all the controllers to initial values....
    if (status == AnimationStatus.completed) {
      _animationController.reset();
      _animationController.forward();
      _animationControllerForGolfBallSize.reset();
      _animationControllerForLoadingOpacity.forward();
      setState(() {
        //change the text to be displayed...
        currentState = 'Loading...';
      });
      // change the opacity of loading text continously....
      _animationControllerForLoadingOpacity.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationControllerForLoadingOpacity.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationControllerForLoadingOpacity.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.barWidth,
      height: MediaQuery.sizeOf(context).height * 0.2,
      child: Column(
        children: [
          Expanded(
              flex: 1,
              //Widget for moving icon and text
              child: LinearLoadingWidget(
                  width: widget.barWidth * 0.97,
                  textColor: widget.textColor,
                  textSize: widget.textSize,
                  animation: _animationForPositions,
                  animationForPercentageText: _animationForPercentage)),
          Expanded(
            flex: 3,
            child: // center design Widget
                CenterLinearBarDesign(
                    animationForBallPosition: _animationForPositions,
                    animationForBallRotation: _animationForBallRotation,
                    animationForBallSize: _animationForBallSize,
                    ballImage: widget.ballImage!,
                    barWidth: widget.barWidth,
                    barHeight: barHeight),
          ),
          // Current State
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.topCenter,
              child: FadeTransition(
                opacity: _animationForTextOpacity,
                child: Text(
                  currentState,
                  style: loadingStyle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
