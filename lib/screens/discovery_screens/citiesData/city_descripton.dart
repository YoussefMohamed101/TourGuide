import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/auth/secrets.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/mostFamousPlaces.dart';
import 'package:untitled2/screens/discovery_screens/famousPlacesForGenPlan.dart';
import 'package:untitled2/screens/discovery_screens/discovery_screen.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/personalGuidersCity.dart';
import 'package:untitled2/screens/fixedSuggestionPlans.dart';
import 'package:untitled2/screens/maps/ShowMap.dart';
import 'package:untitled2/services/GetData.dart';
import 'package:untitled2/services/authentication.dart';

import '../cityPlans.dart';

class imgModel {
  final id;
  final imgURl;
  final numOfDays;
  final numOfSights;
  final description;
  final cityId;
  final planId;

  imgModel({
    this.id,
    this.imgURl,
    this.numOfDays,
    this.numOfSights,
    this.description,
    this.cityId,
    this.planId,
  });
}

class city_preview extends StatefulWidget {
  @override
  State<city_preview> createState() => _city_previewState();
}

class _city_previewState extends State<city_preview> {
  // var UserPhoto;
  // getUser() async {
  //   Auth auth = new Auth();
  //   var user = await auth.getCurrentUser();
  //   var userstore = FirebaseFirestore.instance.collection("users").doc(user?.uid);
  //   await userstore.get().then((value) {
  //     UserPhoto = value.data()?['photourl'];
  //
  //   });
  // }
  //
  // @override
  // void initState() {
  //   startTimer();
  //   getUser();
  //   super.initState();
  // }
  //
  bool isLoading = false; //set loading to false

  // void startTimer() {
  //   Timer.periodic(const Duration(seconds: 1), (t) {
  //     setState(() {
  //       isLoading = false; //set loading to false
  //     });
  //     t.cancel(); //stops the timer
  //   });
  // }

  List<imgModel> imgDetails = [
    imgModel(
      id: '1',
      imgURl: 'lib/img/pexels-daniel-nouri-8253779.jpg',
      numOfDays: '2 days',
      numOfSights: '8 sights',
      description: 'Explore Aswan in 2 days, visit most popular places',
      cityId: 'ZqbIIznmmjgVRwYKJU1b',
      planId: 'YSGmktlJuxSKktpBt9oD',
    ),
    imgModel(
      id: '2',
      imgURl: 'lib/img/pexels-mostafa-el-shershaby-37726330.png',
      numOfDays: '3 days',
      numOfSights: '12 sights',
      description: 'Explore Luxor in 3 day, visit most popular places',
      cityId: 'wsnG3ogBp0QVaOLn1RlV',
      planId: 'UQhSegUwkGmpfFBGmXAM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var city = (ModalRoute.of(context)!.settings.arguments as String);
    late final Future CityData = getCitydata(city);
    print(city);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // systemOverlayStyle: isLoading
        //     ? SystemUiOverlayStyle(
        //         statusBarIconBrightness: Brightness.dark,
        //       )
        //     : SystemUiOverlayStyle(
        //         statusBarIconBrightness: Brightness.light,
        //       ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Color.fromRGBO(249, 168, 38, 1),
              size: 50,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              right: 15.0,
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: userdata23[2],
                fit: BoxFit.fill,
                height: 50,
                width: 50,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: CityData,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 12 / 9,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      width: double.infinity,
                      //height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              '${snapshot.data[0]['imgURL']}'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1), BlendMode.darken),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02,
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 40,
                            ),
                            Text(
                              '${snapshot.data[0]['name']}',
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.045,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.01,
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
                                        const Icon(
                                          Icons.flag,
                                          size: 30,
                                          color:
                                              Color.fromRGBO(249, 168, 38, 1),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Suggestions Plans',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 210,
                                        // ),
                                        const Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                              color: Color.fromRGBO(
                                                  249, 168, 38, 1),
                                            ),
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
                                                  builder: (context) =>
                                                      const cityPlans(),
                                                  settings: RouteSettings(
                                                    arguments: [
                                                      snapshot.data[0]['id'],
                                                      snapshot.data[0]['name']
                                                    ],
                                                  ),
                                                ));
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.045,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.01,
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
                                        const Icon(
                                          Icons.camera_alt,
                                          size: 30,
                                          color:
                                              Color.fromRGBO(249, 168, 38, 1),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'The Most Famous Sites',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 210,
                                        // ),
                                        const Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                              color: Color.fromRGBO(
                                                  249, 168, 38, 1),
                                            ),
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
                                                    builder: (context) =>
                                                        mostFamousePlaces(),
                                                    settings: RouteSettings(
                                                      arguments: snapshot
                                                          .data[0]['id'],
                                                    )));
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.01),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.045,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.01,
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
                                        const Icon(
                                          Icons.remove_red_eye,
                                          size: 30,
                                          color:
                                              Color.fromRGBO(249, 168, 38, 1),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Personal Guider',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 210,
                                        // ),
                                        const Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                              color: Color.fromRGBO(
                                                  249, 168, 38, 1),
                                            ),
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
                                                builder: (context) =>
                                                    personalGuidersCity(),
                                                settings: RouteSettings(
                                                  arguments: snapshot.data[0]
                                                      ['name'],
                                                ),
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
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Suggestions Plans',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                              ),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    buildPlansItem(imgDetails[index]),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 20,
                                ),
                                itemCount: imgDetails.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              return const Text('Please check your connection and try again');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  // 1. build item
  Widget buildPlansItem(imgModel img) => GestureDetector(
    onTap: () async {
      var data = await showPlanDetails(img.cityId, img.planId);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => fixedSuggestionPlans(planDetail: data[0]),
          )
      );
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.bottomLeft,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('${img.imgURl}'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.15), BlendMode.darken),
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 10.0,
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white.withOpacity(0.8),
                        size: 18,
                      ),
                      Text(
                        '${img.numOfDays}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.white.withOpacity(0.8),
                        size: 18,
                      ),
                      Text(
                        '${img.numOfSights}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              '${img.description}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}

// isLoading ?
// Center(
// child: CircularProgressIndicator(
// color: Color.fromRGBO(249, 168, 38, 1),
// )):
