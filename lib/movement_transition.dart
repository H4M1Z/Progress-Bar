import 'package:flutter/material.dart';

class MovementTransition extends AnimatedWidget {
  const MovementTransition(
      {required Animation<double> animation,
      required this.child,
      super.key,
      this.souldMovebottom,
      this.shouldMoveleft,
      this.souldMoveright,
      this.bottom,
      this.left,
      this.right,
      this.top,
      this.shouldMovetop})
      : super(listenable: animation);
  final Widget child;
  final bool? shouldMovetop, souldMovebottom, souldMoveright, shouldMoveleft;
  final double? top, left, right, bottom;

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: shouldMovetop == true ? animation.value : top,
        left: shouldMoveleft == true ? animation.value : left,
        right: souldMoveright == true ? animation.value : right,
        bottom: souldMovebottom == true ? animation.value : bottom,
        child: child);
  }
}
