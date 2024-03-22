import 'package:flutter/material.dart';

// Made a Trasition for generating numbers to improve performance
class NumbersTransition extends AnimatedWidget {
  const NumbersTransition(
      {required Animation<int> animation,
      super.key,
      this.textColor,
      this.textSize})
      : super(listenable: animation);
  final Color? textColor;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<int>;
    return Text(
      '${animation.value}%',
      style: TextStyle(
          color: textColor ?? Colors.black,
          fontSize: textSize ?? 15,
          fontWeight: FontWeight.bold),
    );
  }
}
