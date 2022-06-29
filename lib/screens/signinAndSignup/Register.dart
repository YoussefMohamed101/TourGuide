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
  String? fileName;
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
  final TextEditingController _firstnametextController = TextEditingController();
  final TextEditingController _lastnametextController = TextEditingController();

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
        await FirebaseAuth.instance.signOut();
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
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
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
                                        _loginEmailtextController.text.trim(),
                                        _loginPasstextController.text.trim());
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
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _firstnametextController,
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
                                          labelText: "First Name",
                                          labelStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          fillColor: Colors.white,
                                          filled: true),
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                      keyboardType: TextInputType.name,
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _lastnametextController,
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
                                          labelText: "Last Name",
                                          labelStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          fillColor: Colors.white,
                                          filled: true),
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                      keyboardType: TextInputType.name,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                              TextFormField(
                                controller: _signUpEmailtextController,
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
                                        _signUpEmailtextController.text.trim(),
                                        _signUpPasstextController.text.trim(),
                                        _firstnametextController.text.trim(),
                                        _lastnametextController.text.trim(),
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