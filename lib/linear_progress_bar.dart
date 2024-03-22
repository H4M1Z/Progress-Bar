import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_assignment/linear_bar.dart';
import 'package:flutter_progress_bar_assignment/movement_transition.dart';
import 'package:flutter_progress_bar_assignment/numbers_transition.dart';

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

  //Same image used in the circular progress Bar
  static const golfBallImage = 'assets/images/golfball.png';

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
  late Animation<double> _animationForGolfBallRotation;
  late Animation<double> _animationForGolfBallPosition;
  late Animation<double> _animationForGolfBallSize;
  late Animation<double> _animationForTextOpacity;
  late Animation<AlignmentGeometry> _animationForIcon;
  late Animation<int> _animationForPercentage;
  //Tweens
  final tweenForGolfBallRotation = Tween<double>(begin: 0.0, end: 1.0);
  final tweenForGolfBallSizeAndLoadingOpacity =
      Tween<double>(begin: 1.0, end: 0.0);
  final tweenForPercentage = IntTween(begin: 0, end: 100);

  static const grassImage = 'assets/images/grass.jpg';
  String currentState = 'Loading...';
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

  static late final TextStyle loadingStyle;
  static late final Size defaultBarSize;

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
    _animationForGolfBallRotation =
        tweenForGolfBallRotation.animate(_animationController);
    _animationForGolfBallSize = tweenForGolfBallSizeAndLoadingOpacity
        .animate(_animationControllerForGolfBallSize);
    _animationForTextOpacity = tweenForGolfBallSizeAndLoadingOpacity
        .animate(_animationControllerForLoadingOpacity);
    _animationForPercentage = tweenForPercentage.animate(
        CurvedAnimation(parent: _animationController, curve: widget.curve!));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //The context can't be inherited when we use MediaQuery in init state  so we initialize these variables in this method

    //animation objects
    _animationForGolfBallPosition = Tween<double>(
            begin: widget.barWidth * -0.03, end: widget.barWidth * 0.925)
        .animate(CurvedAnimation(
            parent: _animationController, curve: widget.curve!));
    _animationForIcon = Tween<AlignmentGeometry>(
            begin: Alignment.bottomLeft, end: Alignment.bottomRight)
        .animate(CurvedAnimation(
            parent: _animationController, curve: widget.curve!));

    defaultBarSize = Size(
      MediaQuery.sizeOf(context).width * 0.8,
      MediaQuery.sizeOf(context).height * 0.04,
    );

    loadingStyle = TextStyle(
        color: widget.textColor ?? Colors.black,
        fontSize: widget.textSize ?? 18,
        fontWeight: FontWeight.bold);
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
      // so that the corners are fully rounded
      width: widget.barWidth * 1.1,
      height: MediaQuery.sizeOf(context).height * 0.2,
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: // Icon
                  SizedBox(
                width: widget.barWidth,
                child: Column(
                  children: [
                    //Percentage
                    Expanded(
                        flex: 5,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: widget.barWidth * 0.005),
                          child: AlignTransition(
                              alignment: _animationForIcon,
                              child: NumbersTransition(
                                animation: _animationForPercentage,
                                textColor: widget.textColor,
                                textSize: widget.textSize,
                              )),
                        )),
                    // Icon
                    Expanded(
                      flex: 1,
                      child: AlignTransition(
                          alignment: _animationForIcon,
                          child: Icon(
                            widget.icon ?? Icons.arrow_drop_down_sharp,
                            size: widget.iconSize,
                          )),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                  decoration: containerDecoration,
                  width: widget.barWidth,
                  height: defaultBarSize.height,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Hole(
                          barWidth: widget.barWidth,
                        ),
                      ),

                      //Golf Ball
                      MovementTransition(
                        animation: _animationForGolfBallPosition,
                        shouldMoveleft: true,
                        child: ScaleTransition(
                          scale: _animationForGolfBallSize,
                          child: RotationTransition(
                            turns: _animationForGolfBallRotation,
                            child: SizedBox(
                                width: widget.barWidth * 0.1,
                                height: defaultBarSize.height,
                                child: Image.asset(
                                  widget.ballImage!,
                                )),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
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
