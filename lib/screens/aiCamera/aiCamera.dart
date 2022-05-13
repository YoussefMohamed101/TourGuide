import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AiCamera extends StatefulWidget {
  @override
  _AiCameraState createState() => _AiCameraState();
}

class _AiCameraState extends State<AiCamera> {
  File? _image;

  Future getImagefromcamera() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.camera);
    final imageTemporary = File(photo!.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  Future getImagefromGallery() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imageTemporary = File(photo!.path);
    setState(() {
      _image = imageTemporary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                child: Center(
                  child: _image == null
                      ? const Icon(
                    Icons.add_a_photo,
                    color: Colors.grey,
                    size: 50,
                  )
                      : Image.file(_image!),
                ),
              ),
            ),



            SizedBox(
              height: MediaQuery.of(context).size.height*0.02,
            ),
            const Text(
              "Smart Camera",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(249, 168, 38, 1),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01,
              ),
              child: const Text(
                "Take a picture for a statue to know it\'s details",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ),
            const Expanded(
              child: SizedBox.expand(),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      // <-- ElevatedButton
                      onPressed: () {
                        getImagefromcamera();
                      },
                      child: const Text('Take a picture'),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(249, 168, 38, 1),
                        onPrimary: Colors.white,
                        //shadowColor: Color.fromRGBO(249, 0, 38, 1),
                        elevation: 10,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      // <-- ElevatedButton
                      onPressed: () {getImagefromGallery();},
                      child: const Text('Pick a picture'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: const Color.fromRGBO(249, 168, 38, 1),
                        //shadowColor: Color.fromRGBO(249, 0, 38, 1),
                        elevation: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
