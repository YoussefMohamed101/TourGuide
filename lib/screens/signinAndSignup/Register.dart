import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/screens/home_layout.dart';
import 'package:untitled2/services/authentication.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


// import 'package:simple_animations/simple_animations.dart';
// import 'package:test_project/Modules/Discovery_screens/home_screen.dart';
// import 'package:test_project/Modules/icons.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  File? _image;
  XFile? photo;
  File? imageTemporary;
  //late final savedImage;
  String? fileName;
  //late var imageurl;
  Future getImagefromcamera() async {
    photo = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 25);
    imageTemporary = File(photo!.path);
    setState(() {
      _image = imageTemporary;
    });
    fileName = p.basename(photo!.path);
  }

  Future getImagefromGallery() async {
    photo = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 25);
    imageTemporary = File(photo!.path);
    setState(() {
      _image = imageTemporary;
    });
    fileName = p.basename(photo!.path);
    // final appDir = await getApplicationDocumentsDirectory();
    // final fileName = p.basename(photo.path);
    // savedImage = await File(photo.path).copy('${appDir.path}/$fileName');
  }

  Auth auth = new Auth();
  bool securePass = true;
  bool isSignIn = false;
  final _loginKey = GlobalKey<FormState>();
  final _signUpKey = GlobalKey<FormState>();
  final TextEditingController _loginEmailtextController =
      TextEditingController();
  final TextEditingController _loginPasstextController =
      TextEditingController();
  final TextEditingController _signUpEmailtextController =
      TextEditingController();
  final TextEditingController _signUpPasstextController =
      TextEditingController();
  final TextEditingController _nametextController = TextEditingController();

  bool isLoading = false; //set loading to false

  void _signInStartTimer(sign) {
    Timer.periodic(const Duration(seconds: 3), (t) async {
      var isVerified;
      if(sign){
        isVerified = await auth.isEmailVerified();
      }
      setState(() {
        if (sign) {
          if(isVerified){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Cupertinolayout()),
                    (Route<dynamic> route) => false);
          }
          else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text('Your account is not verified, please check your mail'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
            isLoading = false; //set loading to false
          }
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(auth.err),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
          isLoading = false; //set loading to false
        }
      });
      t.cancel(); //stops the timer
    });
  }

  void _signUpStartTimer(sign) {
    Timer.periodic(const Duration(seconds: 1), (t) async {
      if(sign){
        await auth.sendEmailVerification();
      }
      setState(() {
        if (sign) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Alert'),
              content: Text('We send you an email verification to your email inbox, prees ok when you finish'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    setState(() {
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(builder: (context) => Cupertinolayout()),
                      //         (Route<dynamic> route) => false);
                      Navigator.pop(context);
                      isSignIn = true;
                      isLoading = false;

                    });
                  },
                ),
              ],
            ),
          );
          isLoading = false;
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(auth.err),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
          isLoading = false; //set loading to false
        }
      });
      t.cancel(); //stops the timer
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.signOut();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.235,
                    width: double.infinity,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                        image: AssetImage("lib/img/registerbackground.png"),
                        fit: BoxFit.fill,
                      )),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.178,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 7.0,
                                    color: isSignIn
                                        ? const Color.fromRGBO(249, 168, 50, 1)
                                        : Colors.white, //color of hover
                                  ),
                                ),
                                //color: Colors.white,
                              ),
                              child: Container(
                                child: TextButton(
                                    onPressed: () {
                                      if (!isSignIn) {
                                        isSignIn = true;
                                        setState(() {});
                                      }
                                    },
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Sign in",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: isSignIn
                                                ? Colors.white
                                                : Colors.white),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 7.0,
                                    color: isSignIn
                                        ? Colors.white
                                        : const Color.fromRGBO(
                                            249, 168, 38, 1), //color of hover
                                  ),
                                ),
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    if (isSignIn) {
                                      isSignIn = false;
                                      setState(() {
                                        // email = "";
                                        // pass = "";
                                        // name = "";
                                        // _loginEmailtextController.clear;
                                        // _loginPasstextController.clear;
                                        // _nametextController.clear();
                                      });
                                    }
                                  },
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: isSignIn
                                              ? Colors.white
                                              : Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: isSignIn
                      ? Form(
                          key: _loginKey,
                          child: ListView(
                            padding: const EdgeInsets.all(0.0),
                            children: [
                              const Text(
                                "Welcome back",
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              TextFormField(
                                controller: _loginEmailtextController,
                                onChanged: (val) {
                                  //email = val;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field is Required";
                                  } else if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return "Email not valid";
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    hintText: "name@example.com",
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    fillColor: Colors.white,
                                    filled: true),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                              TextFormField(
                                controller: _loginPasstextController,
                                onChanged: (val) {
                                  // pass = val;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Feild is Required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          securePass = !securePass;
                                        });
                                      },
                                      icon: Icon(
                                        securePass
                                            ? Icons.remove_red_eye
                                            : Icons.security,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                    labelText: "Password",
                                    labelStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    hintText: "Enter your Password",
                                    hintStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    fillColor: Colors.white,
                                    filled: true),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: securePass,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "Forget passwrod?",
                                      style: TextStyle(
                                          fontSize: 21,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w400),
                                    )),
                              ),
                              SizedBox(
                                //between button and sign in button
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_loginKey.currentState!.validate()) {
                                    bool signedIn = await auth.signIn(
                                        _loginEmailtextController.text,
                                        _loginPasstextController.text);
                                    setState(() {
                                      isLoading = true;
                                      _signInStartTimer(signedIn);
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  child: isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          "SIGN IN",
                                          style: TextStyle(
                                            fontSize: 26,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    elevation: 15,
                                    primary:
                                        const Color.fromRGBO(249, 168, 38, 1),
                                    // onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(11))),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Or sign up with",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                //Center Row contents horizontally,
                                children: [
                                  MaterialButton(
                                    onPressed: () {},
                                    child: const Icon(Icons.facebook),
                                    shape: const CircleBorder(),
                                    height: 50,
                                    minWidth: 50,
                                    color:
                                        const Color.fromRGBO(249, 168, 38, 1),
                                    textColor: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : Form(
                          key: _signUpKey,
                          child: ListView(
                            padding: const EdgeInsets.all(0.0),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "New",
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                      ),
                                      const Text(
                                        "Account",
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Container(
                                              height: 120,
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  FloatingActionButton(
                                                    backgroundColor: Color.fromRGBO(249, 168, 38, 1),
                                                    onPressed: (){
                                                      getImagefromcamera();
                                                      Navigator.pop(context);
                                                    },
                                                    tooltip: "Pick Image form gallery",
                                                    child: Icon(Icons.add_a_photo),
                                                  ),
                                                  FloatingActionButton(
                                                    backgroundColor: Color.fromRGBO(249, 168, 38, 1),
                                                    onPressed: (){
                                                      getImagefromGallery();
                                                      Navigator.pop(context);
                                                    },
                                                    tooltip: "Pick Image from camera",
                                                    child: Icon(Icons.camera_alt),
                                                  )
                                                ],
                                              ),
                                            ),
                                            enableDrag: false
                                          );
                                        },
                                        child: _image == null? Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                        ):
                                        Container(
                                          width: 60.0,
                                          height: 60.0,
                                          //color: Colors.black,
                                          child: ClipOval(
                                            child: Image.file(
                                                _image!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        shape: const CircleBorder(),
                                        height: 60,
                                        minWidth: 60,
                                        color: const Color.fromRGBO(
                                            249, 168, 38, 1),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.27,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                            "Upload your profile pucture",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              TextFormField(
                                controller: _nametextController,
                                onChanged: (val) {
                                  // name = val;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field is Required";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    /*border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),*/
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    labelText: "Name",
                                    labelStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    hintText: "Enter your Name",
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    fillColor: Colors.white,
                                    filled: true),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.name,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                              TextFormField(
                                controller: _signUpEmailtextController,
                                onChanged: (val) {
                                  // email = val;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Feild is Required";
                                  } else if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return "Email not Valid";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
/*border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)),*/
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    hintText: "name@example.com",
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    fillColor: Colors.white,
                                    filled: true),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                              TextFormField(
                                controller: _signUpPasstextController,
                                onChanged: (val) {
                                  // pass = val;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Feild is Required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    /*border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)),*/
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          securePass = !securePass;
                                        });
                                      },
                                      icon: Icon(
                                        securePass
                                            ? Icons.remove_red_eye
                                            : Icons.security,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                    labelText: "Password",
                                    labelStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    hintText: "Enter your Password",
                                    hintStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    fillColor: Colors.white,
                                    filled: true),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: securePass,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_signUpKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    bool signedup = await auth.signUp(
                                        _signUpEmailtextController.text,
                                        _signUpPasstextController.text,
                                        _nametextController.text,
                                        fileName,
                                        imageTemporary,
                                    );
                                    _signUpStartTimer(signedup);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  child: isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          "SIGN UP",
                                          style: TextStyle(
                                            fontSize: 26,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    elevation: 15,
                                    primary:
                                        const Color.fromRGBO(249, 168, 38, 1),
                                    // onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(11))),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Or sign up with",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                //Center Row contents horizontally,
                                children: [
                                  MaterialButton(
                                    onPressed: () {},
                                    child: const Icon(Icons.facebook),
                                    shape: const CircleBorder(),
                                    height: 50,
                                    minWidth: 50,
                                    color:
                                        const Color.fromRGBO(249, 168, 38, 1),
                                    textColor: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ));
  }
}

// Widget buildSheet() => Container(
//   child:Row(
//     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     children: <Widget>[
//       FloatingActionButton(
//         backgroundColor: Color.fromRGBO(249, 168, 38, 1),
//         onPressed: getImagefromcamera,
//         tooltip: "Pick Image form gallery",
//         child: Icon(Icons.add_a_photo),
//       ),
//       FloatingActionButton(
//         backgroundColor: Color.fromRGBO(249, 168, 38, 1),
//         onPressed: getImagefromGallery,
//         tooltip: "Pick Image from camera",
//         child: Icon(Icons.camera_alt),
//       )
//     ],
//   ),
// );

// class FadeAnimation extends StatelessWidget {
//   final double delay;
//   final Widget child;
//
//   FadeAnimation(this.delay, this.child);
//
//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTrackTween([
//       Track("opacity")
//           .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
//       Track("translateY").add(
//           Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
//           curve: Curves.easeOut)
//     ]);
//
//     return ControlledAnimation(
//       delay: Duration(milliseconds: (500 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builderWithChild: (context, child, animation) => Opacity(
//         opacity: animation["opacity"],
//         child: Transform.translate(
//             offset: Offset(0, animation["translateY"]), child: child),
//       ),
//     );
//   }
// }

/*
* Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: isSignIn
                              ? ListView(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Welcome back",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        /*CircleAvatar(radius: 32,
                                    backgroundColor: Color.fromRGBO(86, 97, 246, 1),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 45,
                                    ),
                                  )*/
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),

                                        TextFormField(
                                          onChanged: (val) {
                                            email = val;
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Feild is Required";
                                            } else if (!RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(email)) {
                                              return "Email not Valid";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
/*border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),*/
                                              prefixIcon: const Icon(
                                                Icons.email,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                              labelText: "Email",
                                              labelStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              hintText: "name@example.com",
                                              hintStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              fillColor: Colors.white,
                                              filled: true),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),

                                        TextFormField(
                                          onChanged: (val) {
                                            pass = val;
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Feild is Required";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              /*border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(20))*/
                                              prefixIcon: const Icon(
                                                Icons.lock,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    securePass = !securePass;
                                                  });
                                                },
                                                icon: Icon(
                                                  securePass
                                                      ? Icons.remove_red_eye
                                                      : Icons.security,
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                              ),
                                              labelText: "Password",
                                              labelStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              hintText: "Enter your Password",
                                              hintStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              fillColor: Colors.white,
                                              filled: true),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: securePass,
                                        ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                            TextButton(
                                                onPressed: () {},
                                                child: const Text(
                                                  "Forget passwrod?",
                                                  style: TextStyle(
                                                      fontSize: 21,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ))
                                      ],
                                    ),
                                    SizedBox(
                                      //between button and sign in button
                                      height: 50.0,
                                    ),

                                        ElevatedButton(
                                          onPressed: () {
                                            if (_key.currentState!.validate()) {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           home_screen(),
                                              //     ));
                                            }
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 13),
                                            child: Text(
                                              "SIGN IN",
                                              style: TextStyle(
                                                fontSize: 26,
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              elevation: 15,
                                              primary: Color.fromRGBO(
                                                  249, 168, 38, 1),
                                              // onPrimary: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          11))),
                                        ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Or sign up with",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        /*FadeAnimation(
                                  3.5,
                                  TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "Log in",
                                        style: TextStyle(
                                            fontSize: 21,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900),
                                      )))*/
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   //Center Row contents horizontally,
                                    //   children: [
                                    //     MaterialButton(
                                    //       onPressed: () {},
                                    //       child: Icon(Icons.facebook),
                                    //       shape: CircleBorder(),
                                    //       height: 50,
                                    //       minWidth: 50,
                                    //       color:
                                    //           Color.fromRGBO(249, 168, 38, 1),
                                    //       textColor: Colors.white,
                                    //     ),
                                    //     SizedBox(
                                    //       width: 15,
                                    //     ),
                                    //     MaterialButton(
                                    //       onPressed: () {},
                                    //       child: Icon(MyFlutterApp.google),
                                    //       shape: CircleBorder(),
                                    //       height: 50,
                                    //       minWidth: 50,
                                    //       color:
                                    //           Color.fromRGBO(249, 168, 38, 1),
                                    //       textColor: Colors.white,
                                    //     )
                                    //   ],
                                    // )
                                  ],
                                )
                              : ListView(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "New",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Text(
                                              "Account",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: const [
                                            Icon(
                                              Icons.camera_alt,
                                              color: Color.fromRGBO(
                                                  249, 168, 38, 1),
                                              size: 45,
                                            ),
                                            Text(
                                              "Upload your",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              "profile pucture",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),

                                        TextFormField(
                                          onChanged: (val) {
                                            name = val;
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Feild is Required";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              /*border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),*/
                                              prefixIcon: const Icon(
                                                Icons.person,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                              labelText: "Name",
                                              labelStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              hintText: "Enter your Name",
                                              hintStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              fillColor: Colors.white,
                                              filled: true),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.name,
                                        ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),

                                        TextFormField(
                                          onChanged: (val) {
                                            email = val;
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Feild is Required";
                                            } else if (!RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(email)) {
                                              return "Email not Valid";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
/*border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),*/
                                              prefixIcon: const Icon(
                                                Icons.email,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                              labelText: "Email",
                                              labelStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              hintText: "name@example.com",
                                              hintStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              fillColor: Colors.white,
                                              filled: true),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),

                                        TextFormField(
                                          onChanged: (val) {
                                            pass = val;
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Feild is Required";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              /*border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),*/
                                              prefixIcon: const Icon(
                                                Icons.lock,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    securePass = !securePass;
                                                  });
                                                },
                                                icon: Icon(
                                                  securePass
                                                      ? Icons.remove_red_eye
                                                      : Icons.security,
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                              ),
                                              labelText: "Password",
                                              labelStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              hintText: "Enter your Password",
                                              hintStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              fillColor: Colors.white,
                                              filled: true),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: securePass,
                                        ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                    ),

                                        ElevatedButton(
                                          onPressed: () {
                                            if (_key.currentState!.validate()) {}
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 13),
                                            child: Text(
                                              "SIGN UP",
                                              style: TextStyle(
                                                fontSize: 26,
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              elevation: 15,
                                              primary: Color.fromRGBO(
                                                  249, 168, 38, 1),
                                              // onPrimary: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          11))),
                                        ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Or sign up with",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          /*FadeAnimation(
                                    3.5
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          "Sign in",
                                          style: TextStyle(
                                              fontSize: 21,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900),
                                        )))*/
                                        ],
                                      ),

                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    // FadeAnimation(
                                    //   6,
                                    //   Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.center,
                                    //     //Center Row contents horizontally,
                                    //     children: [
                                    //       MaterialButton(
                                    //         onPressed: () {},
                                    //         child: Icon(Icons.facebook),
                                    //         shape: CircleBorder(),
                                    //         height: 50,
                                    //         minWidth: 50,
                                    //         color:
                                    //             Color.fromRGBO(249, 168, 38, 1),
                                    //         textColor: Colors.white,
                                    //       ),
                                    //       SizedBox(
                                    //         width: 15,
                                    //       ),
                                    //       MaterialButton(
                                    //         onPressed: () {},
                                    //         child: Icon(MyFlutterApp.google),
                                    //         shape: CircleBorder(),
                                    //         height: 50,
                                    //         minWidth: 50,
                                    //         color:
                                    //             Color.fromRGBO(249, 168, 38, 1),
                                    //         textColor: Colors.white,
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                        ),
                      ),
                    ),
* */
