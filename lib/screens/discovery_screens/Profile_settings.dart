import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/auth/secrets.dart';
import 'package:untitled2/screens/aboutUsPage.dart';
import 'package:untitled2/screens/accountSettings.dart';
import 'package:untitled2/screens/myPlans.dart';
import 'package:untitled2/screens/signinAndSignup/Register.dart';
import 'package:untitled2/services/GetData.dart';

class ProfileSettings extends StatefulWidget {

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {

  bool isLoading = true; //set loading to false
  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (t) async {
      await getUser();
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),):StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").doc(userid).snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if(snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.1,
                  left: MediaQuery
                      .of(context)
                      .size
                      .width * 0.08,
                  right: MediaQuery
                      .of(context)
                      .size
                      .width * 0.08,
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data['photourl'],
                            fit: BoxFit.fill,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${snapshot.data['firstName']} ${snapshot.data['lastName']}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.01,
                              ),
                              Text(
                                '${snapshot.data['Email']}',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.08,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery
                            .of(context)
                            .size
                            .width * 0.02,
                      ),
                      child: SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.045,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.01,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    size: 30,
                                    // color: Color.fromRGBO(249, 168, 38, 1),
                                  ),
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.05,
                                  ),
                                  const Text(
                                    'My Profile',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox.expand(
                              child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => accountSettings(),
                                        ),
                                      );
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery
                            .of(context)
                            .size
                            .width * 0.02,
                      ),
                      child: SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.045,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.01,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.map,
                                    size: 30,
                                    // color: Color.fromRGBO(249, 168, 38, 1),
                                  ),
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.05,
                                  ),
                                  const Text(
                                    'My Plans',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox.expand(
                              child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => myPlans(),
                                        ),
                                      );
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery
                            .of(context)
                            .size
                            .width * 0.02,
                      ),
                      child: SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.045,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.01,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    size: 30,
                                    // color: Color.fromRGBO(249, 168, 38, 1),
                                  ),
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.05,
                                  ),
                                  const Text(
                                    'About App and help',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox.expand(
                              child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => aboutUsPage(),
                                        ),
                                      );
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery
                            .of(context)
                            .size
                            .width * 0.02,
                        vertical: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02,
                      ),
                      child: SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.045,
                        child: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(
                                top: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.01,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.logout,
                                    size: 30,
                                    // color: Color.fromRGBO(249, 168, 38, 1),
                                  ),
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.05,
                                  ),
                                  const Text(
                                    'SignOut',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox.expand(
                              child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.of(context, rootNavigator: true)
                                          .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => Register()),
                                              (Route<dynamic> route) => false);
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }
      ),
    );
  }
}
