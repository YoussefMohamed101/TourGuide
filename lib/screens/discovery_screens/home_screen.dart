import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/screens/discovery_screens/discovery_screen.dart';
import 'package:untitled2/services/authentication.dart';
import 'package:cached_network_image/cached_network_image.dart';

class home_screen extends StatefulWidget {
  @override
  State<home_screen> createState() => _home_screenState();
}

class User {
  final id;
  final Name;
  final imgURl;
  final CurrentLocation;

  User({
    required this.id,
    required this.Name,
    required this.imgURl,
    required this.CurrentLocation,
  });
}

class imgModel {
  final id;
  final title;
  final shortDescription;
  final imgURl;
  final goverName;

  imgModel({
    this.id,
    this.title,
    this.shortDescription,
    this.imgURl,
    this.goverName,
  });
}

List<imgModel> ProgDetails = [
  imgModel(
    id: '1',
    imgURl: 'lib/img/home/pexels-photo-3290075.png',
    title: 'Summer in Egypt',
    shortDescription: '15 differnt places and plans to dicover and visit',
    goverName: 'Cairo',
  ),
  imgModel(
      id: '2',
      imgURl: 'lib/img/home/popular place luxor.png',
      title: 'Find New Places',
      shortDescription: '20 Temples to visit, explore and make adventures',
      goverName: 'Luxor'),
  imgModel(
      id: '3',
      imgURl: 'lib/img/home/popoular place in giza cairo.png',
      title: 'Summer in Egypt',
      shortDescription: '15 differnt places and plans to dicover and visit',
      goverName: 'Giza'),
];

class _home_screenState extends State<home_screen> {
  var Username;
  var UserPhoto;
  var userlocalpic;
  getUser() async {
    Auth auth = new Auth();
    var user = await auth.getCurrentUser();
    userlocalpic = user?.photoURL;
    var userstore = FirebaseFirestore.instance.collection("users").doc(user?.uid);
    await userstore.get().then((value) {
      // Username = value
        Username = value.data()?['username'];
        UserPhoto = value.data()?['photourl'];
    });
  }

  @override
  void initState() {
    // imageCache!.clear();
    // imageCache!.clearLiveImages();
    startTimer();
    getUser();
    super.initState();
  }

  // List<User> user = [
  //   User(
  //       id: '1',
  //       Name: 'user',
  //       imgURl: 'lib/img/home/hema.png',
  //       CurrentLocation: 'Egypt'),
  // ];

  bool isLoading = true; //set loading to false

  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        isLoading = false; //set loading to false
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
          systemOverlayStyle: isLoading? SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
          ):SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
          ),
        ),
        body: isLoading ?
        Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(249, 168, 38, 1),
            )):Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.35,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'lib/img/home/homepage background.png'),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5), BlendMode.darken),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hi, ${Username}',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      Text(
                                        'Current Location, ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.all(0.0),
                                              alignment: Alignment.topLeft,
                                              primary: Colors.transparent,
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              'Egypt',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                decoration:
                                                TextDecoration.underline,
                                                //decorationStyle: TextDecorationStyle.double,
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            UserPhoto== null?
                            ClipOval(
                              child: Image.asset("$userlocalpic",fit: BoxFit.fill,height: 60,width: 60,),
                            ):
                            ClipOval(
                              child: CachedNetworkImage(imageUrl:UserPhoto,fit: BoxFit.fill,height: 60,width: 60,),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                          top: MediaQuery.of(context).size.height * 0.24,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                Offset(1, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            onFieldSubmitted: (String value) {
                              print(value);
                            },
                            onChanged: (String value) {
                              print(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Where do you want to go?',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color.fromRGBO(249, 168, 38, 1),
                              ),
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(249, 168, 38, 1),
                                fontWeight: FontWeight.bold,
                              ),
                              errorStyle: TextStyle(
                                color: Colors.red,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(249, 168, 38, 1),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04,
                      ),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top:
                                    MediaQuery.of(context).size.height * 0.02,
                                    bottom: 15.0,
                                    left: 2,
                                  ),
                                  child: Text(
                                    'What do you want to do?',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                    MediaQuery.of(context).size.width * 0.07,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          // <-- ElevatedButton
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => discovery_screen(),
                                                ));
                                          },
                                          icon: Icon(
                                            Icons.add_location_outlined,
                                            size: 24.0,
                                          ),
                                          label: Text('Discovery'.toUpperCase()),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            onPrimary:
                                            Color.fromRGBO(249, 168, 38, 1),
                                            //shadowColor: Color.fromRGBO(249, 0, 38, 1),
                                            elevation: 10,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          // <-- ElevatedButton
                                          onPressed: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //       builder: (context) => Show_Maps(),
                                            //     ));
                                            setState(() {

                                            });
                                          },
                                          icon: Icon(
                                            Icons.map,
                                            size: 24.0,
                                          ),
                                          label: Text('MAp'.toUpperCase()),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            onPrimary:
                                            Color.fromRGBO(249, 168, 38, 1),
                                            //shadowColor: Color.fromRGBO(249, 0, 38, 1),
                                            elevation: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                    MediaQuery.of(context).size.width * 0.07,
                                    vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    //height: 40,
                                    child: ElevatedButton(
                                      // <-- ElevatedButton
                                      onPressed: () {},
                                      child: Text(
                                        'Generate plan'.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromRGBO(249, 168, 38, 1),
                                        elevation: 5,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                    MediaQuery.of(context).size.height * 0.01,
                                    left: 2,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Popular Places',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliverGrid(
                            gridDelegate:
                            SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.0,
                              mainAxisSpacing: 30.0,
                              crossAxisSpacing: 20.0,
                              childAspectRatio: 1.0,
                              mainAxisExtent: 244,
                            ),
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) =>
                                  buildProgItem(context, ProgDetails[index]),
                              childCount: ProgDetails.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      );
  }

  // 1. build item
  Widget buildProgItem(BuildContext context, imgModel ProgDetails) => Stack(
        children: [
          Container(
            width: 200,
            height: 244,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                5.0,
              ),
              image: DecorationImage(
                image: AssetImage('${ProgDetails.imgURl}'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.darken),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${ProgDetails.title}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Text(
                  '${ProgDetails.shortDescription}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(
                      '${ProgDetails.goverName}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.bookmark,
            color: Color.fromRGBO(249, 168, 38, 1),
            size: 30,
          ),
        ],
      );

//Widget buildChatItem() => Padding(
//         padding: const EdgeInsets.all(1.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 202,
//                         height: 244,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             5.0,
//                           ),
//                           image: DecorationImage(
//                             image:
//                                 AssetImage('lib/img/pexels-photo-3290075.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'Summer in Egypt',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Text(
//                                 '15 differnt places and plans to dicover and visit',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                   Text(
//                                     'Cairo',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.bookmark,
//                         color: Color.fromRGBO(249, 168, 38, 1),
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 202,
//                         height: 244,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             5.0,
//                           ),
//                           image: DecorationImage(
//                             image:
//                                 AssetImage('lib/img/popular place luxor.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'Find New Places',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Text(
//                                 '20 Temples to visit, explore and make adventures',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                   Text(
//                                     'Luxor',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.bookmark,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 202,
//                         height: 244,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             5.0,
//                           ),
//                           image: DecorationImage(
//                             image: AssetImage('lib/img/cairo.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'Summer in Egypt',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Text(
//                                 '15 differnt places and plans to dicover and visit',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                   Text(
//                                     'Giza',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.bookmark,
//                         color: Color.fromRGBO(249, 168, 38, 1),
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: 202,
//                         height: 244,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                             5.0,
//                           ),
//                           image: DecorationImage(
//                             image: AssetImage('lib/img/Aswan.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'Find New Places',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Text(
//                                 '20 Temples to visit, explore and make adventures',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                   Text(
//                                     'Aswan',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.bookmark,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
}
