import 'package:myapp/Model/textInfo.dart';
import 'package:flutter/material.dart';

class ImageText extends StatelessWidget {
  final textScaleFactor;
  final TextInfo textInfo;
  const ImageText({super.key, required this.textInfo, this.textScaleFactor});

  @override
  Widget build(BuildContext context) {
    return Text(
      textInfo.text,
      textAlign: textInfo.textAlign,
      textScaleFactor: textScaleFactor,
      style: TextStyle(
        fontSize: textInfo.fontSize,
        fontWeight: textInfo.fontWeight,
        fontStyle: textInfo.fontStyle,
        color: textInfo.color,
      ),
    );
  }
}
