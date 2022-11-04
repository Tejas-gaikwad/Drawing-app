import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:myapp/drawingApp-1.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ImageText.dart';
import 'buttonWidget.dart';
import 'editImage.dart';

class MapArea {
  Offset point;
  Paint areaPaint;

  MapArea({required this.areaPaint, required this.point});
}

class DrawingApp_2 extends StatefulWidget {
  final image;
  const DrawingApp_2({super.key, required this.image});

  @override
  State<DrawingApp_2> createState() => _DrawingApp_2State();
}

class _DrawingApp_2State extends EditImage {
  GlobalKey _globalKey = GlobalKey();

  List<MapArea?> points = [];
  Color? selectedColor;
  double? strokeWidth;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  List<Color> colorList = [];

  void selectColor() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            // ignore: prefer_const_constructors
            title: Text("Color Chooser"),
            content: BlockPicker(
                pickerColor: selectedColor!,
                onColorChanged: (color) {
                  setState(() {
                    selectedColor = color;
                    colorList.add(color);
                  });
                }),
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10), child: Text("Ok")))
            ],
          );
        }));
  }

  bool _isLoading = false;

  List imagesList = [];

  Future<void> _save() async {
    setState(() {
      _isLoading = true;
    });
    RenderRepaintBoundary? boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));

    if (!(await Permission.storage.status.isGranted)) {
      await Permission.storage.request();
    }

    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      imagesList.add(result['filePath']);
      setState(() {
        _isLoading = false;
      });
      bool _imageSaved = false;
      if (result['isSuccess'] == true) {
        setState(() {
          _imageSaved = true;
        });
      } else {
        setState(() {
          _imageSaved = false;
        });
      }

      result['isSuccess'] == true
          ? Fluttertoast.showToast(
              msg: "Image saved succesfully...",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.pink,
              fontSize: 16.0,
            )
          : Fluttertoast.showToast(
              msg: "Error, Please try again.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.pink,
              fontSize: 16.0,
            );
    }
    // Uint8List pngBytes = byteData!.buffer.asUint8List();
    // if (!(await Permission.storage.status.isGranted))
    //   await Permission.storage.request();
    // final result = await ImageGallerySaver.saveImage(Uint8List(pngBytes),
    //     quality: 60, name: "canvas Image");
    // print(result);
  }

  bool showDrawBox = false;

  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;

  double _scale = 1.0;
  double previousScale = 1.0;

  bool makeTextScalale = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          height: MediaQuery.of(context).size.height,
          width: width,
          decoration: BoxDecoration(
            // ignore: unnecessary_null_comparison
            gradient: colorList.length == 0
                ? const LinearGradient(colors: [
                    Colors.black,
                    Colors.black,
                  ])
                : colorList.length == 1
                    ? LinearGradient(colors: [
                        Colors.black,
                        colorList[0],
                      ])
                    : colorList.length == 2
                        ? LinearGradient(colors: [
                            Colors.black,
                            colorList[0],
                            colorList[1],
                          ])
                        : LinearGradient(colors: [
                            Colors.black,
                            colorList[0],
                            colorList[1],
                            colorList[2],
                          ]),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    RepaintBoundary(
                      key: _globalKey,
                      child: SizedBox(
                        width: width * 0.98,
                        height: height * 0.85,
                        child: GestureDetector(
                          onScaleStart: (ScaleStartDetails details) {
                            print(details);
                            // _initialFocalPoint = details.focalPoint;
                            if (showDrawBox == true) {
                              setState(() {
                                points.add(MapArea(
                                  point: details.focalPoint,
                                  areaPaint: Paint()
                                    ..strokeCap = StrokeCap.round
                                    ..color = selectedColor!
                                    ..strokeWidth = strokeWidth!
                                    ..isAntiAlias = true,
                                ));
                              });
                            } else {}
                            previousScale = _scale;
                          },
                          onScaleUpdate: (ScaleUpdateDetails details) {
                            print(details.scale.toString() + "------------");
                            if (showDrawBox == true) {
                              setState(() {
                                points.add(MapArea(
                                    point: details.focalPoint,
                                    areaPaint: Paint()
                                      ..strokeCap = StrokeCap.round
                                      ..color = selectedColor!
                                      ..strokeWidth = strokeWidth!
                                      ..isAntiAlias = true));
                              });
                            } else {}
                            setState(() {
                              _scale = previousScale * details.scale;
                            });
                            changeSize(_scale);
                          },
                          onScaleEnd: (ScaleEndDetails details) {
                            print(details);
                            setState(() {
                              points.add(null);
                            });
                            previousScale = 1.0;
                            setState(() {});
                          },

                          // onPanDown: (details) {
//  if (showDrawBox == true) {
//                               setState(() {
//                                 points.add(MapArea(
//                                   point: details.globalPosition,
//                                   areaPaint: Paint()
//                                     ..strokeCap = StrokeCap.round
//                                     ..color = selectedColor!
//                                     ..strokeWidth = strokeWidth!
//                                     ..isAntiAlias = true,
//                                 ));
//                               });
//                             } else {}
                          // },
                          // onPanUpdate: (details) {
                          //   if (showDrawBox == true) {
                          //     setState(() {
                          //       points.add(MapArea(
                          //           point: details.localPosition,
                          //           areaPaint: Paint()
                          //             ..strokeCap = StrokeCap.round
                          //             ..color = selectedColor!
                          //             ..strokeWidth = strokeWidth!
                          //             ..isAntiAlias = true));
                          //     });
                          //   } else {}
                          // },
                          // onPanEnd: (details) {
                          // setState(() {
                          //   points.add(null);
                          // });
                          // },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                widget.image!,
                                fit: BoxFit.fill,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: CustomPaint(
                                  size: Size(width * 0.98, height * 0.85),
                                  painter: MyCustomPainter(
                                    points: points,
                                    selectColor: selectedColor,
                                    disable: false,
                                  ),
                                ),
                              ),
                              for (int i = 0; i < texts.length; i++)
                                Positioned(
                                  left: texts[i].left,
                                  top: texts[i].top,
                                  child: Draggable(
                                    feedback: ImageText(
                                        textInfo: texts[i],
                                        textScaleFactor: _scale),
                                    child: GestureDetector(
                                      onTap: () {
                                        print(
                                            i.toString() + "================");
                                        setCurrenIndex(
                                          context,
                                          i,
                                        );
                                      },
                                      // onScaleStart:
                                      //     (ScaleStartDetails details) {
                                      //   print(details);
                                      //   // _initialFocalPoint = details.focalPoint;
                                      //   previousScale = _scale;
                                      // },
                                      // onScaleUpdate:
                                      //     (ScaleUpdateDetails details) {
                                      //   print(details.scale.toString() +
                                      //       "------------");

                                      //   setState(() {
                                      //     _scale =
                                      //         previousScale * details.scale;
                                      //   });
                                      // },
                                      // onScaleEnd: (ScaleEndDetails details) {
                                      //   print(details);
                                      //   previousScale = 1.0;
                                      //   setState(() {});
                                      // },
                                      // onScaleStart: (details) {
                                      //   print("Strat....................");
                                      //   print(details.toString() +
                                      //       ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
                                      //   _initialScale = _scaleFactor;

                                      //   print(details.toString() +
                                      //       "--------------");
                                      // },
                                      // onScaleUpdate: (details) {
                                      //   print(details.toString() +
                                      //       ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
                                      //   setState(() {
                                      //     _scaleFactor =
                                      //         _initialScale * details.scale;
                                      //   });
                                      //   print(_scaleFactor.toString() +
                                      //       "''''''''''''''''''''''''''''''''");
                                      // },
                                      child:
                                          //  Transform.translate(
                                          //   offset: _offset + _sessionOffset,
                                          //   child: Transform.scale(
                                          //     scale: _scale,
                                          //     child: Container(
                                          //       padding: const EdgeInsets.all(12.0),
                                          //       color: Colors.red,
                                          //       child: Text(
                                          //         "Flutter123467890",
                                          //         // textScaleFactor: _scale,
                                          //         // style: TextStyle(fontSize: 30),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),

                                          ImageText(
                                        textInfo: texts[i],
                                        textScaleFactor: texts[i].scaleData,
                                      ),
                                    ),
                                    onDragEnd: (drag) {
                                      final renderBox = context
                                          .findRenderObject() as RenderBox;
                                      Offset off =
                                          renderBox.globalToLocal(drag.offset);

                                      setState(() {
                                        texts[i].top = off.dy;
                                        texts[i].left = off.dx;
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: InkWell(
                        onTap: () {
                          _save();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 50,
                                spreadRadius: 3,
                                offset: Offset(0.0, 0.0))
                          ]),
                          child: const Text(
                            "DONE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: InkWell(
                        onTap: () => backShowDialog(context),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 50,
                                spreadRadius: 3,
                                offset: Offset(0.0, 0.0))
                          ]),
                          child: const Text(
                            "BACK",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _isLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.pink,
                          ))
                        : const SizedBox(),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      showDrawBox == true
                          ? Row(
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
                                        onPressed: () {
                                          selectColor();
                                        },
                                        icon: Icon(Icons.color_lens,
                                            color: selectedColor),
                                      ),
                                      Expanded(
                                        child: Slider(
                                          min: 1.0,
                                          max: 10.0,
                                          activeColor: selectedColor,
                                          value: strokeWidth!,
                                          onChanged: (value) {
                                            setState(() {
                                              strokeWidth = value;
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            points.clear();
                                          });
                                        },
                                        icon: const Icon(Icons.layers_clear),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      showDrawBox = false;
                                    });
                                  },
                                  child: Container(
                                      // color: Colors.white,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                )
                              ],
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  print("true============");
                                  showDrawBox = true;
                                });
                              },
                              child: AnimatedContainer(
                                alignment: Alignment.center,
                                height: 40,
                                duration: Duration(seconds: 1),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: Text("Draw"),
                              ),
                            ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () => addNewDialog(context),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  List<MapArea?> points;
  Color? selectColor;
  final disable;

  MyCustomPainter({
    required this.disable,
    required this.points,
    required this.selectColor,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    Paint background = Paint()..color = Colors.transparent;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    if (disable == true) {
    } else {
      for (int x = 0; x < points.length - 1; x++) {
        if (points[x] != null && points[x + 1] != null) {
          Paint paint = points[x]!.areaPaint;
          canvas.drawLine(points[x]!.point, points[x + 1]!.point, paint);
        } else if (points[x] != null && points[x + 1] == null) {
          Paint paint = points[x]!.areaPaint;
          canvas.drawPoints(PointMode.points, [points[x]!.point], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
