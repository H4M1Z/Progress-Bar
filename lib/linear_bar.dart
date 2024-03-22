import 'package:flutter/widgets.dart';
import 'package:flutter_progress_bar_assignment/progress_bar_painter.dart';

class Hole extends StatelessWidget {
  const Hole({super.key, this.barWidth});
  final double? barWidth;

  @override
  Widget build(BuildContext context) {
    final defaultBarSize = Size(MediaQuery.sizeOf(context).width * 0.8,
        MediaQuery.sizeOf(context).height * 0.04);
    return CustomPaint(
      painter: HolePainter(),
      size: Size(defaultBarSize.width - MediaQuery.sizeOf(context).width * 0.74,
          defaultBarSize.height - MediaQuery.sizeOf(context).height * 0.008),
    );
  }
}
