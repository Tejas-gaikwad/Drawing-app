import 'package:flutter/material.dart';

class DrawWidgetRowContent extends StatelessWidget {
  final width;
  final selectedColor;
  final onTap1;
  final onPressed1;
  final onPressed2;
  final onChanged3;
  final strokeWidth;
  const DrawWidgetRowContent(
      {super.key,
      this.width,
      this.selectedColor,
      this.onTap1,
      this.onPressed1,
      this.onChanged3,
      this.onPressed2,
      this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: Duration(seconds: 1),
          height: 40,
          // margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          width: width * 0.60,
          child: Row(
            children: [
              IconButton(
                onPressed: onPressed1,
                icon: Icon(
                  Icons.color_lens,
                  color: selectedColor,
                ),
              ),
              Expanded(
                child: Slider(
                  min: 1.0,
                  max: 10.0,
                  activeColor: selectedColor,
                  value: strokeWidth!,
                  onChanged: onChanged3,
                ),
              ),
              IconButton(
                onPressed: onPressed2,
                icon: const Icon(Icons.layers_clear),
              )
            ],
          ),
        ),
        InkWell(
          onTap: onTap1,
          child: Container(
              // color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.cancel,
                color: Colors.white,
                size: 30,
              )),
        )
      ],
    );
  }
}
