import 'package:flutter/material.dart';

import 'DrawingApp_2.dart';
import 'Model/textInfo.dart';
import 'buttonWidget.dart';
import 'drawingApp-1.dart';

abstract class EditImage extends State<DrawingApp_2> {
  TextEditingController textController = TextEditingController();
  List<TextInfo> texts = [];
  List<ScaleEndDetails> scaleList = [];

  bool textWriting = false;

  // bool shoWborder = false;

  int currentIndex = 0;

  setCurrenIndex(BuildContext context, index, showBorder) {
    setState(() {
      currentIndex = index;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Selected")));
  }

  changeSize(scaleData) {
    setState(() {
      texts[currentIndex].scaleData = scaleData;
    });
  }

  changeAngle(angleData) {
    setState(() {
      texts[currentIndex].angleData = angleData;
    });
  }

  addNewText(BuildContext context) {
    setState(
      () {
        texts.add(
          TextInfo(
            text: textController.text,
            left: MediaQuery.of(context).size.width / 2,
            top: MediaQuery.of(context).size.height / 2,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            textAlign: TextAlign.left,
            scaleData: 1.0,
            showBorder: true,
            radius: Radius.circular(10.0),
            padding: EdgeInsets.all(10.0),
            borderColor: Colors.white,
            dashPattern: [3, 1],
            angleData: 0.0,
          ),
        );
        textController.clear();
      },
    );

    Navigator.pop(context);
  }

  addNewDialog(context) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text(
              "Add text here...",
            ),
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            actions: <Widget>[
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink),
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonWidget(
                        textColor: Colors.white,
                        color: Colors.pink,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      ButtonWidget(
                        textColor: Colors.white,
                        color: Colors.white,
                        onPressed: () => addNewText(context),
                        child: const Text(
                          "Ok",
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
        }));

    if (textWriting == true) {
      setState(() {
        textWriting = false;
      });
    } else if (textWriting == false) {
      setState(() {
        textWriting = true;
      });
    }
  }

  backShowDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure? Exit?"),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonWidget(
                  textColor: Colors.white,
                  color: Colors.pink,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                ButtonWidget(
                  textColor: Colors.white,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const DrawingApp_1();
                      },
                    ));
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}



//Got the solution......................