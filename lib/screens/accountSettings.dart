import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/auth/secrets.dart';
import 'package:untitled2/services/GetData.dart';
import 'package:path/path.dart' as p;

class accountSettings extends StatefulWidget {
  const accountSettings({Key? key}) : super(key: key);

  @override
  State<accountSettings> createState() => _accountSettingsState();
}

class _accountSettingsState extends State<accountSettings> {

  File? _image;
  XFile? photo;
  File? imageTemporary;
  String? fileName;
  
  bool showChangeName = false;
  bool showChangePassword = false;
  bool securePass = true;

  final _changeName = GlobalKey<FormState>();
  final _changePassword = GlobalKey<FormState>();
  final TextEditingController _firstNameTextController = TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  Future getImagefromcamera() async {
    photo = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 25);
    imageTemporary = File(photo!.path);
    setState(() {
      _image = imageTemporary;
    });
    fileName = p.basename(photo!.path);
    updatePhoto();
  }

  Future getImagefromGallery() async {
    photo = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 25);
    imageTemporary = File(photo!.path);
    setState(() {
      _image = imageTemporary;
    });
    fileName = p.basename(photo!.path);
    updatePhoto();
  }

  Future<void> updatePhoto() async {
    var user = FirebaseAuth.instance.currentUser;
    var imageurl;
    try {
      var ref = FirebaseStorage.instance.ref('Images')
          .child('Users')
          .child('${user!.uid}')
          .child('$fileName');
      await ref.putFile(imageTemporary!);
      imageurl = await ref.getDownloadURL();
    } on FirebaseAuthException catch (e) {
      print('asdasd');
      print(e.toString());
    }

    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update(
        {
          "photourl": imageurl,
        });

    setState(() {

    });

  }

  Future<void> updateName(String firstName,String lastName) async {
    var user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update(
        {
          "firstName": firstName,
          "lastName": lastName,
        }).then((value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Name changed successfully'),
          content: Text('Name changed successfully'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  showChangeName = false;
                });
              },
            ),
          ],
        ),
      );
        }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Name changed Failed'),
          content: Text('Failed changing Name, try again later'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  showChangeName = false;
                });
              },
            ),
          ],
        ),
      );
    });

    setState(() {

    });

  }

  void changePassword(String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: userdata23[3], password: currentPassword);

    user!.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Password changed successfully'),
            content: Text('Your Password changed successfully'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    showChangePassword = false;
                    _oldPasswordController.clear();
                    _newPasswordController.clear();
                  });
                },
              ),
            ],
          ),
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Password changed Failed'),
            content: Text('Failed changing Password, try again later'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    showChangePassword = false;
                    _oldPasswordController.clear();
                    _newPasswordController.clear();
                  });
                },
              ),
            ],
          ),
        );
      });
    }).catchError((err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('The password is invalid'),
          content: Text('Check your old password and try again'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  showChangePassword = false;
                  _oldPasswordController.clear();
                  _newPasswordController.clear();
                });
              },
            ),
          ],
        ),
      );

    });}

  @override
  Widget build(BuildContext context) {
    _firstNameTextController.text = userdata23[0];
    _lastNameTextController.text = userdata23[1];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              PlacesList = [];
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              size: 45,
            )),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      userdata23[2],
                    ),
                    fit: BoxFit.fill
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                      elevation: 8,
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                      shape: const CircleBorder(),
                      height: 40,
                      minWidth: 40,
                      color: const Color.fromRGBO(
                          249, 168, 38, 1),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Align(
                alignment: Alignment.center,
                child: Text(
                    '${userdata23[0]} ${userdata23[1]}',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                    '${userdata23[3]}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )

            ),

            SizedBox(height: 50,),

            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height*0.01,
                      horizontal: MediaQuery.of(context).size.width*0.03,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.045,
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height*0.01,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Change name',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                // SizedBox(
                                //   width: 210,
                                // ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: showChangeName?Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 30,
                                    ):Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox.expand(
                            child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(onTap: () {
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) => Dialog(
                                  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                                  //     child: Container(
                                  //       height: 350.0,
                                  //       width: 350.0,
                                  //
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Column(
                                  //           mainAxisAlignment: MainAxisAlignment.center,
                                  //           crossAxisAlignment: CrossAxisAlignment.end,
                                  //           children: <Widget>[
                                  //             Form(
                                  //               key: _changeName,
                                  //               child: Column(
                                  //
                                  //                 children: [
                                  //
                                  //                   TextFormField(
                                  //                     controller: _firstNameTextController,
                                  //                     onChanged: (val) {
                                  //                       // name = val;
                                  //                     },
                                  //                     validator: (value) {
                                  //                       if (value!.isEmpty) {
                                  //                         return "Field is Required";
                                  //                       }
                                  //                       return null;
                                  //                     },
                                  //                     decoration: const InputDecoration(
                                  //                       border: OutlineInputBorder(
                                  //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  //                       ),
                                  //                       prefixIcon: Icon(
                                  //                         Icons.person,
                                  //                         color: Colors.black,
                                  //                         size: 30,
                                  //                       ),
                                  //                       labelText: "First Name",
                                  //                       labelStyle: TextStyle(
                                  //                           fontSize: 18,
                                  //                           fontWeight: FontWeight.bold,
                                  //                           color: Colors.black
                                  //                       ),
                                  //                     ),
                                  //                     style: const TextStyle(
                                  //                         fontSize: 18, fontWeight: FontWeight.bold),
                                  //                     textAlign: TextAlign.left,
                                  //                     keyboardType: TextInputType.name,
                                  //                   ),
                                  //                   SizedBox(height: 20,),
                                  //                   TextFormField(
                                  //                     controller: _lastNameTextController,
                                  //                     onChanged: (val) {
                                  //                       // name = val;
                                  //                     },
                                  //                     validator: (value) {
                                  //                       if (value!.isEmpty) {
                                  //                         return "Field is Required";
                                  //                       }
                                  //                       return null;
                                  //                     },
                                  //                     decoration: const InputDecoration(
                                  //                         border: OutlineInputBorder(
                                  //                           borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  //                         ),
                                  //                         prefixIcon: Icon(
                                  //                           Icons.person,
                                  //                           color: Colors.black,
                                  //                           size: 30,
                                  //                         ),
                                  //                         labelText: "Last Name",
                                  //                         labelStyle: TextStyle(
                                  //                             fontSize: 18,
                                  //                             fontWeight: FontWeight.bold,
                                  //                             color: Colors.black),
                                  //                         fillColor: Colors.white,
                                  //                         filled: true),
                                  //                     style: const TextStyle(
                                  //                         fontSize: 18, fontWeight: FontWeight.bold),
                                  //                     textAlign: TextAlign.left,
                                  //                     keyboardType: TextInputType.name,
                                  //                   ),
                                  //                   SizedBox(
                                  //                     //between button and sign in button
                                  //                     height:
                                  //                     MediaQuery.of(context).size.height * 0.06,
                                  //                   ),
                                  //                   Row(
                                  //                     mainAxisAlignment: MainAxisAlignment.end,
                                  //                     children: [
                                  //                       TextButton(onPressed: () {
                                  //                         if (_changeName.currentState!.validate()) {
                                  //                           Navigator.pop(context);
                                  //                           updateName(_firstNameTextController.text.trim(), _lastNameTextController.text.trim());
                                  //                         }
                                  //                       },
                                  //                           child: Text(
                                  //                             'Save',
                                  //                             style: TextStyle(fontSize: 18.0),
                                  //                           )
                                  //                       ),
                                  //                       TextButton(onPressed: () {
                                  //                         Navigator.of(context).pop();
                                  //                       },
                                  //                           child: Text(
                                  //                             'Cancel',
                                  //                             style: TextStyle(color:Colors.black,fontSize: 18.0),
                                  //                           )
                                  //                       ),
                                  //                     ],
                                  //                   )
                                  //
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // );
                                  setState(() {
                                    showChangeName = !showChangeName;
                                  });
                                },)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showChangeName,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Form(
                            key: _changeName,
                            child: Column(

                              children: [

                                TextFormField(
                                  controller: _firstNameTextController,
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    labelText: "First Name",
                                    labelStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.name,
                                ),
                                SizedBox(height: 20,),
                                TextFormField(
                                  controller: _lastNameTextController,
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
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
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
                                SizedBox(
                                  //between button and sign in button
                                  height:
                                  MediaQuery.of(context).size.height * 0.06,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(onPressed: () {
                                      if (_changeName.currentState!.validate()) {
                                        updateName(_firstNameTextController.text.trim(), _lastNameTextController.text.trim());
                                      }
                                    },
                                        child: Text(
                                          'Save',
                                          style: TextStyle(fontSize: 18.0),
                                        )
                                    ),
                                    TextButton(onPressed: () {
                                      setState(() {
                                        showChangeName = false;
                                      });
                                    },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color:Colors.black,fontSize: 18.0),
                                        )
                                    ),
                                  ],
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height*0.01,
                      horizontal: MediaQuery.of(context).size.width*0.03,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.045,
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height*0.01,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Change Password',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                // SizedBox(
                                //   width: 210,
                                // ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: showChangePassword?Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 30,
                                    ):Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox.expand(
                            child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(onTap: () {
                                  setState(() {
                                    showChangePassword = !showChangePassword;
                                  });

                                },)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showChangePassword,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Form(
                            key: _changePassword,
                            child: Column(

                              children: [

                                TextFormField(
                                  controller: _oldPasswordController,
                                  onChanged: (val) {
                                    // name = val;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Field is Required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    prefixIcon: Icon(
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
                                    labelText: "Enter old password",
                                    labelStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: securePass,
                                ),
                                SizedBox(height: 20,),
                                TextFormField(
                                  controller: _newPasswordController,
                                  onChanged: (val) {
                                    // name = val;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Field is Required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      prefixIcon: Icon(
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
                                      labelText: "Enter new password",
                                      labelStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      fillColor: Colors.white,
                                      filled: true),
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: securePass,
                                ),
                                SizedBox(
                                  //between button and sign in button
                                  height:
                                  MediaQuery.of(context).size.height * 0.06,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(onPressed: () {
                                      if (_changePassword.currentState!.validate()) {
                                        changePassword(_oldPasswordController.text.trim(),_newPasswordController.text.trim());
                                      }
                                    },
                                        child: Text(
                                          'Save',
                                          style: TextStyle(fontSize: 18.0),
                                        )
                                    ),
                                    TextButton(onPressed: () {
                                      setState(() {
                                        showChangePassword = false;
                                        _oldPasswordController.clear();
                                        _oldPasswordController.clear();
                                      });
                                    },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color:Colors.black,fontSize: 18.0),
                                        )
                                    ),
                                  ],
                                )

                              ],
                            ),
                          ),
                        ],
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
