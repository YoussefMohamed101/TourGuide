import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:async';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class AiCamera extends StatefulWidget {
  @override
  _AiCameraState createState() => _AiCameraState();
}

class _AiCameraState extends State<AiCamera> {
  List? _outputs;
  File? _image;
  bool _loading = false;
  var _statueData;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  getDataOfStatue(statueName) async {
    if (statueName != 'null') {
      var connection = FirebaseFirestore.instance.collection('Statues');
      await connection
          .where('name', isEqualTo: '$statueName')
          .get()
          .then((value) {
        for (var item in value.docs) {
          _statueData = item.data()['information'];
          print(_statueData);
        }
      });
    } else {
      _statueData = 'Cannot Found Information';
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Statues Camera',
          style: TextStyle(
            fontSize: 30
          ),
        ),
      ),
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _image == null
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 250.0,
                                child: Center(
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            const Text(
                              "Statues Camera",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(249, 168, 38, 1),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.01,
                              ),
                              child: const Text(
                                "Take a picture for a statue to know it\'s details",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height*0.25,
                                child: Center(
                                  child: Image.file(_image!),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            (_outputs != null && _outputs![0]['confidence'] > 0.8)
                                ? Text(
                                    "${_outputs![0]['label']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      background: Paint()..color = Colors.white,
                                    ),
                                  )
                                : Text(
                              "We couldn't figure out this statue,Please try again",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                background: Paint()..color = Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),

                          ],
                        ),
                  (_outputs != null && _outputs![0]['confidence'] > 0.8)?
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),

                      ),
                      height: 100,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.aspectRatio*25
                        ),
                        child: ListView(
                          children: [
                            Text('${_statueData}',
                              style: TextStyle(
                                fontSize: 22,
                                height: MediaQuery.of(context).size.height*0.0015
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ):
                  const Expanded(
                    child: SizedBox.expand(),
                  ),
                  Row(
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
                          onPressed: () {
                            getImagefromGallery();
                          },
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
                ],
              ),
            ),
    );
  }

  Future getImagefromcamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return null;
    final imageTemporary = File(image.path);
    setState(() {
      _loading = true;
      _image = imageTemporary;
    });
    classifyImage(imageTemporary);
  }

  Future getImagefromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    final imageTemporary = File(image.path);
    setState(() {
      _loading = true;
      _image = imageTemporary;
    });
    classifyImage(imageTemporary);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    print(output);
    if(output!.isEmpty){
      _outputs = null;
      setState(() {
        _loading = false;
      });
    }
    else{
      print('555555555555555555555555555555555555555555555555555555555');
      _outputs = output;
      getDataOfStatue(_outputs![0]["label"]);
    }


  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model3.tflite",
      labels: "assets/labels2.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}

// Padding(
// padding: const EdgeInsets.all(15.0),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.end,
// children: [
// Padding(
// padding: const EdgeInsets.all(16.0),
// child: Container(
// width: MediaQuery.of(context).size.width,
// height: 250.0,
// child: Center(
// child: _image == null
// ? const Icon(
// Icons.add_a_photo,
// color: Colors.grey,
// size: 50,
// )
// : Image.file(_image!),
// ),
// ),
// ),
//
//
//
// SizedBox(
// height: MediaQuery.of(context).size.height*0.02,
// ),
// const Text(
// "Smart Camera",
// style: TextStyle(
// fontSize: 40,
// fontWeight: FontWeight.w600,
// color: Color.fromRGBO(249, 168, 38, 1),
// ),
// ),
// SizedBox(
// height: MediaQuery.of(context).size.height*0.02,
// ),
// Padding(
// padding: EdgeInsets.symmetric(
// horizontal: MediaQuery.of(context).size.width * 0.01,
// ),
// child: const Text(
// "Take a picture for a statue to know it\'s details",
// textAlign: TextAlign.center,
// style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
// ),
// ),
// const Expanded(
// child: SizedBox.expand(),
// ),
// Expanded(
// child: Row(
// children: [
// Expanded(
// child: ElevatedButton(
// // <-- ElevatedButton
// onPressed: () {
// getImagefromcamera();
// },
// child: const Text('Take a picture'),
// style: ElevatedButton.styleFrom(
// primary: const Color.fromRGBO(249, 168, 38, 1),
// onPrimary: Colors.white,
// //shadowColor: Color.fromRGBO(249, 0, 38, 1),
// elevation: 10,
// ),
// ),
// ),
// const SizedBox(
// width: 20,
// ),
// Expanded(
// child: ElevatedButton(
// // <-- ElevatedButton
// onPressed: () {getImagefromGallery();},
// child: const Text('Pick a picture'),
// style: ElevatedButton.styleFrom(
// primary: Colors.white,
// onPrimary: const Color.fromRGBO(249, 168, 38, 1),
// //shadowColor: Color.fromRGBO(249, 0, 38, 1),
// elevation: 10,
// ),
// ),
// ),
// ],
// ),
// ),
// ElevatedButton(
// // <-- ElevatedButton
// onPressed: () {
// testmodel();
// },
// child: const Text('Take a picture'),
// style: ElevatedButton.styleFrom(
// primary: const Color.fromRGBO(249, 168, 38, 1),
// onPrimary: Colors.white,
// //shadowColor: Color.fromRGBO(249, 0, 38, 1),
// elevation: 10,
// ),
// ),
//
// ],
// ),
// ),
