import 'package:flutter/widgets.dart';
import 'package:flutter_progress_bar_assignment/progress_bar_painter.dart';

class Hole extends StatelessWidget {
  const Hole({super.key, this.barWidth});
  final double? barWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HolePainter(),
      size: Size(barWidth! * 0.055, MediaQuery.sizeOf(context).height * 0.03),
    );
  }
}
