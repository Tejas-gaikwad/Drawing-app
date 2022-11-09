import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ImageWidgetScreen extends StatelessWidget {
  final widgetGive;

  ImageWidgetScreen({super.key, required this.widgetGive});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      widgetGive!,
      fit: BoxFit.fill,
    );
  }
}
