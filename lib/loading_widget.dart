import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_assignment/numbers_transition.dart';

class LinearLoadingWidget extends StatelessWidget {
  const LinearLoadingWidget(
      {super.key,
      required this.width,
      required this.textColor,
      required this.textSize,
      required this.animation,
      required this.animationForPercentageText,
      this.iconSize,
      this.icon});
  final double width;
  final Animation<AlignmentGeometry> animation;
  final Animation<int> animationForPercentageText;
  final Color? textColor;
  final double? textSize, iconSize;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          //Percentage Text
          Expanded(
              flex: 5,
              //move the percentage with the ball
              child: AlignTransition(
                  alignment: animation,
                  // (Made a numbers transition widget as there is no built in widget availabke for it and also to improve the performance)
                  child: NumbersTransition(
                    animation: animationForPercentageText,
                    textColor: textColor,
                    textSize: textSize,
                  ))),
          // Icon
          Expanded(
            flex: 1,
            //move the icon with the ball
            child: AlignTransition(
                alignment: animation,
                child: Icon(
                  icon ?? Icons.arrow_drop_down_sharp,
                  size: iconSize,
                )),
          ),
        ],
      ),
    );
  }
}
