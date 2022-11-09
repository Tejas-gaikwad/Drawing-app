import 'package:flutter/material.dart';

class DrawWidget extends StatelessWidget {
  final onTap;
  const DrawWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        alignment: Alignment.center,
        height: 40,
        duration: Duration(seconds: 1),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Text("Draw"),
      ),
    );
  }
}
