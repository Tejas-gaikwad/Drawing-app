import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' show get;
import 'DrawingApp_2.dart';

class DrawingApp_1 extends StatefulWidget {
  const DrawingApp_1({super.key});

  @override
  State<DrawingApp_1> createState() => _DrawingApp_1State();
}

class _DrawingApp_1State extends State<DrawingApp_1> {
  File? _image;

  final imagePicker = ImagePicker();
  late bool itsStart;

  Future getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(image!.path);
    });
  }

  // Image loadImageFromFile(String path) {
  //   File file = new File(path);
  //   Image img = Image.file(file);
  // }

  // void storeImageToFile(String path, String url) async {
  //   var response = await get(Url);
  //   File file = File(path);
  //   file.create(recursive: true).then((val) async {
  //     if (await val.exists()) {
  //       file.writeAsBytesSync(response.bodyBytes);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: _image == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    const Text(
                      "No photo Available! Please... Add Photo",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    GestureDetector(
                      onTap: getImage,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    // Expanded(
                    //     child: ListView.builder(
                    //         itemCount: 6,
                    //         itemBuilder: ((context, index) {
                    //           return Container(
                    //             height: 50,
                    //             width: 150,
                    //             margin: EdgeInsets.only(top: 10),
                    //             color: Colors.red,
                    //           );
                    //         }))),
                  ],
                )
              : DrawingApp_2(
                  image: _image,
                ),
        ),
      ),
    );
  }
}
