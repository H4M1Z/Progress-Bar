import 'package:flutter/material.dart';
import 'package:flutter_progress_bar_assignment/circular_progress_bar.dart';
import 'package:flutter_progress_bar_assignment/linear_progress_bar.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar(
      {super.key,
      required this.duration,
      required this.progressBarType,
      this.linearBarWidth,
      this.textColor,
      this.iconSizeForLinearBar,
      this.textSize,
      this.outerBarColorForCircularBar,
      this.curve = Curves.slowMiddle,
      this.innerBarColorForCircularBar,
      this.ballImage = 'assets/images/golfball.png',
      this.iconForLinearBar,
      this.circularBarSize});
  final Duration duration;
  final ProgressBarType progressBarType;
  final String? ballImage;
  final IconData? iconForLinearBar;
  final Color? textColor,
      outerBarColorForCircularBar,
      innerBarColorForCircularBar;
  final double? textSize, iconSizeForLinearBar, linearBarWidth;
  final Curve? curve;
  final Size? circularBarSize;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: progressBarType == ProgressBarType.linear
          ? LinearProgressBar(
              duration: duration,
              ballImage: ballImage,
              icon: iconForLinearBar,
              barWidth:
                  linearBarWidth ?? MediaQuery.sizeOf(context).width * 0.8,
              textColor: textColor,
              textSize: textSize,
              iconSize: iconSizeForLinearBar,
              curve: curve,
            )
          : CircularProgressBar(
              duration: duration,
              textColor: textColor,
              textSize: textSize,
              ballImage: ballImage,
              innerBarColor: innerBarColorForCircularBar,
              outerBarColor: outerBarColorForCircularBar,
              curve: curve,
              size: circularBarSize ??
                  Size(MediaQuery.sizeOf(context).width * 0.3,
                      MediaQuery.sizeOf(context).height * 0.23),
            ),
    );
  }
}

enum ProgressBarType {
  linear,
  circular,
}
