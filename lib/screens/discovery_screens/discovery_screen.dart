import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/auth/secrets.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/city_descripton.dart';
import 'package:untitled2/services/GetData.dart';

class discovery_screen extends StatefulWidget {
  @override
  State<discovery_screen> createState() => _discovery_screenState();
}

class imgModel1 {
  final id;
  final imgURl;
  final goverName;

  imgModel1({
    this.id,
    this.imgURl,
    this.goverName,
  });
}

class _discovery_screenState extends State<discovery_screen> {
  List<imgModel1> goverDetails = [
    imgModel1(
        id: '1', imgURl: 'lib/img/discovery/Giza.png', goverName: 'Giza'),
    imgModel1(
        id: '2',
        imgURl: 'lib/img/discovery/Luxor.png',
        goverName: 'Luxor'),
    imgModel1(
        id: '3', imgURl: 'lib/img/discovery/Cairo.png', goverName: 'Cairo'),
    imgModel1(
        id: '4', imgURl: 'lib/img/discovery/Aswan.png', goverName: 'Aswan'),
  ];

  // @override
  // void initState() {
  //   startTimer();
  //   getUser();
  //   super.initState();
  // }
  bool isLoading = false; //set loading to false

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  late final Future CityData = getCities();

  @override
  Widget build(BuildContext context) {
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
              color: const Color.fromRGBO(249, 168, 38, 1),
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
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              return Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.35,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            image: const AssetImage(
                                "lib/img/discovery/discovery background.png"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.6), BlendMode.dstATop),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery
                              .of(context)
                              .size
                              .height * 0.15,
                        ),
                        child: const Text(
                          'Discovery',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery
                              .of(context)
                              .size
                              .height * 0.21,
                          left: MediaQuery
                              .of(context)
                              .size
                              .width * 0.1,
                          right: MediaQuery
                              .of(context)
                              .size
                              .width * 0.1,
                        ),
                        child: const Text(
                          'You can explore different places around the world with just one click',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery
                            .of(context)
                            .size
                            .width * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.03,
                                vertical: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.012,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset:
                                      const Offset(1, 10), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Explore Cities',
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomScrollView(
                                slivers: <Widget>[
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                          (context, index) =>
                                          buildChatItem(
                                              context, snapshot.data[index]),
                                      childCount: snapshot.data.length,
                                    ),
                                  ),
                                ],
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
            if(snapshot.hasError){
              return const Text('Please check your connection and try again');
            }
            return const Center(child: CircularProgressIndicator());
          }

      ),
    );
  }

  // 1. build item
  Widget buildChatItem(BuildContext context, var snapshot) =>
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => city_preview(),
                settings: RouteSettings(
                  arguments: snapshot['id'],
                ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            alignment: Alignment.bottomLeft,
            //width: 336,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                20.0,
              ),
              image: DecorationImage(
                image: CachedNetworkImageProvider('${snapshot['imgURL']}'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.darken),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery
                    .of(context)
                    .size
                    .width * 0.05,
                horizontal: MediaQuery
                    .of(context)
                    .size
                    .height * 0.015,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 35,
                  ),
                  Text(
                    '${snapshot['name']}',
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
