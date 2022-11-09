import 'package:flutter/material.dart';

class TextMaker extends StatelessWidget {
  final onTap;
  const TextMaker({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(100.0),
        ),
        padding: const EdgeInsets.all(2),
        child: const Text(
          "A",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
