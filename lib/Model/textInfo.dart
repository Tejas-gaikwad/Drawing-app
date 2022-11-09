import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInfo {
  String text;
  double left;
  double top;
  Color color;
  FontWeight fontWeight;
  FontStyle fontStyle;
  double fontSize;
  TextAlign textAlign;
  double scaleData;
  double angleData;
  bool showBorder = false;
  List<double>? dashPattern;
  final radius;
  final padding;
  final borderColor;

  TextInfo(
      //
      {
    required this.dashPattern,
    this.radius,
    this.padding,
    this.borderColor = Colors.white,
    required this.text,
    required this.left,
    required this.top,
    required this.color,
    required this.fontWeight,
    required this.fontStyle,
    required this.fontSize,
    required this.textAlign,
    required this.scaleData,
    required this.showBorder,
    required this.angleData,
  });
}
