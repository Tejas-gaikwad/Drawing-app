import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  double _scale = 1.0;
  double previousScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onScaleStart: (ScaleStartDetails details) {
            print(details);
            // _initialFocalPoint = details.focalPoint;
            previousScale = _scale;
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            print(details.scale.toString() + "------------");

            setState(() {
              _scale = previousScale * details.scale;
            });
          },
          onScaleEnd: (ScaleEndDetails details) {
            print(details);
            previousScale = 1.0;
            setState(() {});
          },
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.purple,
              child: Text(
                "Tejas gaikwad",
                textScaleFactor: _scale,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
