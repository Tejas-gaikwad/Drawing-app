import 'package:dotted_border/dotted_border.dart';
import 'package:myapp/Model/textInfo.dart';
import 'package:flutter/material.dart';

class ImageText extends StatelessWidget {
  final textScaleFactor;
  final TextInfo textInfo;
  final angleData;
  ImageText({
    super.key,
    required this.textInfo,
    this.textScaleFactor,
    required this.angleData,
  });

  @override
  Widget build(BuildContext context) {
    return
        // textInfo.showBorder == true
        //     ? Container(
        //         child: TextWidget(
        //           angle: textInfo.angleData,
        //           text: textInfo.text,
        //           color: textInfo.color,
        //           fontSize: textInfo.fontSize,
        //           fontStyle: textInfo.fontStyle,
        //           fontWeight: textInfo.fontWeight,
        //           textAlign: textInfo.textAlign,
        //           textScaleFactor: textScaleFactor,
        //         ),
        //       )
        //     :
        TextWidget(
      text: textInfo.text,
      // color: textInfo.color,
      color: Colors.pink,
      fontSize: textInfo.fontSize,
      fontStyle: textInfo.fontStyle,
      fontWeight: textInfo.fontWeight,
      textAlign: textInfo.textAlign,
      textScaleFactor: textScaleFactor,
      angle: textInfo.angleData,
    );
  }
}

class TextWidget extends StatelessWidget {
  final text;
  final textAlign;
  final textScaleFactor;
  final fontSize;
  final fontWeight;
  final fontStyle;
  final color;
  final angle;
  const TextWidget({
    super.key,
    required this.text,
    this.textAlign,
    this.textScaleFactor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.color,
    this.angle,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        // decoration: BoxDecoration(
        //     border: Border.all(
        //   color: Colors.white,
        //   width: 0.2,
        // )),
        child: Text(
          text,
          textAlign: textAlign,
          textScaleFactor: textScaleFactor,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: color,
          ),
        ),
      ),
    );
  }
}
