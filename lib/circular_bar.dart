import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_assignment/progress_bar_painter.dart';

// Made a seperate widget for circular bar as I used built-in ransition widgets for better performance and in this widget I used Explicit animation...
class CircularBar extends StatefulWidget {
  const CircularBar(
      {super.key,
      required this.duration,
      this.curve,
      this.outerBarColor,
      this.innerBarColor,
      required this.size});
  final Duration duration;
  final Color? outerBarColor, innerBarColor;
  final Curve? curve;
  final Size size;

  @override
  State<CircularBar> createState() => _CircularBarState();
}

class _CircularBarState extends State<CircularBar>
    with SingleTickerProviderStateMixin {
//controller
  late AnimationController _animationController;
//animation
  late Animation<double> _animation;
//Tween
  final tweenForLoadingLine = Tween<double>(begin: 0.0, end: 200.5);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration)
          ..addListener(() {
            setState(() {});
          })
          ..repeat();
    // start the aniation when the ball reaches the hole
    _animation = tweenForLoadingLine.animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.34, 0.9473, curve: widget.curve!)));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircularProgressBarPainter(
          barAngle: _animation.value,
          outerbarColor: widget.outerBarColor,
          innerBarColor: widget.innerBarColor),
      size: Size(widget.size.width - MediaQuery.sizeOf(context).width * 0.03,
          widget.size.height - MediaQuery.sizeOf(context).height * 0.05),
    );
  }
}
