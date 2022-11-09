import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DoneWidget extends StatelessWidget {
  final onTap;
  var top;
  var bottom;
  var right;
  var left;
  final buttonName;
  DoneWidget({
    super.key,
    required this.onTap,
    required this.buttonName,
    this.top,
    this.bottom,
    this.right,
    this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      top: top,
      left: left,
      bottom: bottom,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 50,
                spreadRadius: 3,
                offset: Offset(0.0, 0.0))
          ]),
          child: Text(
            buttonName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
