import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:myapp/Drawing/ImageFileWidget.dart';
import 'package:myapp/Drawing/customPainter.dart';
import 'package:myapp/Testing/test.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Drawing/DrawWidgetRow.dart';
import 'Drawing/doneWidget.dart';
import 'Drawing/drawWidget.dart';
import 'Drawing/textMaker.dart';
import 'ImageText.dart';
import 'editImage.dart';

typedef MatrixGestureDetectorCallback = void Function(
    Matrix4 matrix, Matrix4 rotationDeltaMatrix);

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
  static Matrix4 compose(Matrix4? matrix, Matrix4? rotationMatrix) {
    if (matrix == null) matrix = Matrix4.identity();

    if (rotationMatrix != null) matrix = rotationMatrix * matrix;
    return matrix!;
  }

  ///
  /// Decomposes [matrix] into [MatrixDecomposedValues.translation],
  /// [MatrixDecomposedValues.scale] and [MatrixDecomposedValues.rotation] components.
  ///
  static decomposeToValues(Matrix4 matrix) {
    var array = matrix.applyToVector3Array([0, 0, 0, 1, 0, 0]);
    Offset delta = Offset(array[3] - array[0], array[4] - array[1]);
    double rotation = delta.direction;
    // print(rotation.toString() + "RRRRRRRRRRRRRRRRRRRRRRRR");
    return rotation;
  }

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

  double rotation = 0.0;
  var lastRotation = 0.0;

  bool makeTextScalale = false;

  bool showborder = false;

  Matrix4 rotationDeltaMatrix = Matrix4.identity();
  Matrix4 matrix = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    var res = decomposeToValues(matrix);
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
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //   ],
                // ),
                Stack(
                  // fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    RepaintBoundary(
                      key: _globalKey,
                      child: SizedBox(
                        width: width * 1,
                        height: height * 0.9,
                        child: GestureDetector(
                          onScaleStart: onScaleStart,
                          onScaleUpdate: onScaleUpdate,
                          onScaleEnd: onScaleEnd,
                          child: Stack(
                            // fit: StackFit.expand,
                            children: [
                              Image.file(
                                widget.image!,
                                fit: BoxFit.cover,
                                height: height * 0.9,
                              ),
                              CustomPainterScreen(
                                width: width * 1,
                                height: height * 0.9,
                                points: points,
                                selectedColor: selectedColor,
                              ),
                              for (int i = 0; i < texts.length; i++)
                                Positioned(
                                  left: texts[i].left,
                                  top: texts[i].top,
                                  child: Draggable(
                                    feedback: ImageText(
                                      textInfo: texts[i],
                                      textScaleFactor: _scale,
                                      angleData: res,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setCurrenIndex(context, i, showborder);
                                      },
                                      child: ImageText(
                                        textInfo: texts[i],
                                        textScaleFactor: texts[i].scaleData,
                                        angleData: texts[i].angleData,
                                      ),
                                    ),
                                    /////// Change Dragging feature.................
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
                    DoneWidget(
                      left: 10.0,
                      top: 20.0,
                      buttonName: "DONE",
                      onTap: () {
                        _save();
                      },
                    ),
                    DoneWidget(
                      right: 10.0,
                      top: 20.0,
                      onTap: () => backShowDialog(context),
                      buttonName: "Back",
                    ),
                    _isLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.pink,
                          ))
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      showDrawBox == true
                          ? DrawWidgetRowContent(
                              onChanged3: (value) {
                                setState(() {
                                  strokeWidth = value;
                                });
                              },
                              onPressed1: () {
                                selectColor();
                              },
                              onPressed2: () {
                                setState(() {
                                  points.clear();
                                });
                              },
                              onTap1: () {
                                setState(() {
                                  showDrawBox = false;
                                });
                              },
                              selectedColor: selectedColor,
                              strokeWidth: strokeWidth,
                              width: width,
                            )
                          : DrawWidget(
                              onTap: () => setState(() {
                                    showDrawBox = true;
                                  })),
                      SizedBox(width: 10),
                      // textWriting == true
                      //     ?
                      TextMaker(onTap: () {
                        addNewDialog(context);
                        setState(() {
                          showDrawBox = false;
                        });
                      })
                      // : InkWell(
                      //     onTap: () {
                      //       selectColor();
                      //     },
                      //     child: Container(
                      //       padding: EdgeInsets.all(8.0),
                      //       color: Colors.white,
                      //       child: Icon(Icons.color_lens),
                      //     ),
                      //   ),
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

  _ValueUpdater<double> rotationUpdater = _ValueUpdater(
    value: 0.0,
    onUpdate: (oldVal, newVal) => newVal - oldVal,
  );

  void onScaleStart(ScaleStartDetails details) {
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
    } else {
      rotationUpdater.value = 0.0;
    }
    previousScale = _scale;
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    // print(details.scale.toString() + "------------");
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
    } else {
      setState(() {
        _scale = previousScale * details.scale;
      });
      changeSize(_scale);

      // handle matrix rotating
      if (details.rotation != 0.0) {
        double rotationDelta = rotationUpdater.update(details.rotation);
        rotationDeltaMatrix = _rotate(rotationDelta, details.focalPoint);
        matrix = rotationDeltaMatrix * matrix;
      }

      decomposeToValues(matrix);

      setState(() {
        rotationDeltaMatrix = matrix;
        var rotation = decomposeToValues(matrix);
        changeAngle(rotation);
      });
    }
  }

  void onScaleEnd(ScaleEndDetails details) {
    print(details);
    setState(() {
      points.add(null);
    });
    rotation = 0.0;
    previousScale = 1.0;
    setState(() {});
  }

  Matrix4 _rotate(double angle, Offset focalPoint) {
    var c = cos(angle);
    var s = sin(angle);
    var dx = (1 - c) * focalPoint.dx + s * focalPoint.dy;
    var dy = (1 - c) * focalPoint.dy - s * focalPoint.dx;

    //  ..[0]  = c       # x scale
    //  ..[1]  = s       # y skew
    //  ..[4]  = -s      # x skew
    //  ..[5]  = c       # y scale
    //  ..[10] = 1       # diagonal "one"
    //  ..[12] = dx      # x translation
    //  ..[13] = dy      # y translation
    //  ..[15] = 1       # diagonal "one"
    return Matrix4(c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
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

typedef _OnUpdate<T> = T Function(T oldValue, T newValue);

class _ValueUpdater<T> {
  final _OnUpdate<T> onUpdate;
  T value;

  _ValueUpdater({
    required this.value,
    required this.onUpdate,
  });

  T update(T newValue) {
    T updated = onUpdate(value, newValue);
    value = newValue;
    return updated;
  }
}

class MatrixDecomposedValues {
  /// Translation, in most cases useful only for matrices that are nothing but
  /// a translation (no scale and no rotation).

  /// Rotation in radians, (-pi..pi) range.
  final double rotation;

  MatrixDecomposedValues(this.rotation);

  @override
  String toString() {
    return 'MatrixDecomposedValues( rotation: ${rotation.toStringAsFixed(3)})';
  }
}
