import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../DrawingApp_2.dart';

class CustomPainterScreen extends StatelessWidget {
  final width;
  final height;
  final points;
  final selectedColor;
  const CustomPainterScreen({
    super.key,
    required this.width,
    required this.height,
    required this.points,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: CustomPaint(
        size: Size(width, height),
        painter: MyCustomPainter(
          points: points,
          selectColor: selectedColor,
          disable: false,
        ),
      ),
    );
  }
}
