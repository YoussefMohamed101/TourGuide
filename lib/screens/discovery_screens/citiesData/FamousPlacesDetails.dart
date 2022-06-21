import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled2/services/GetData.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FamousePlacesDetails extends StatefulWidget {
  const FamousePlacesDetails({Key? key}) : super(key: key);

  @override
  State<FamousePlacesDetails> createState() => _FamousePlacesDetailsState();
}

class _FamousePlacesDetailsState extends State<FamousePlacesDetails> {
  int active = 0;

  @override
  Widget build(BuildContext context) {
    List daysName = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];
    var placeInfo = (ModalRoute.of(context)!.settings.arguments as List);
    // print('*****************************************$placeInfo **************************************');
    late final Future cityPlaces = getPlacedata(placeInfo);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Color.fromRGBO(249, 168, 38, 1),
              size: 50,
            )),
      ),
      body: FutureBuilder(
          future: cityPlaces,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              log(snapshot.toString());
              var numOfOpeningPerDay =
                  snapshot.data[0]['timesOfWork']['Sunday'].length;
              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Stack(
                      children: [
                        CarouselSlider.builder(
                          itemCount: snapshot.data[0]['img'].length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              Container(
                            alignment: Alignment.bottomLeft,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    '${snapshot.data[0]['img'][itemIndex]}'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.1),
                                    BlendMode.darken),
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.35,
                            autoPlay: true,
                            autoPlayAnimationDuration:
                                const Duration(seconds: 1),
                            onPageChanged: (index, reason) {
                              setState(() {
                                active = index;
                              });
                            },
                            autoPlayCurve: Curves.ease,
                            viewportFraction: 1,
                            // enableInfiniteScroll: false,
                            // enlargeCenterPage: true,
                            // enlargeStrategy: CenterPageEnlargeStrategy.scale
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedSmoothIndicator(
                              activeIndex: active,
                              count: snapshot.data[0]['img'].length,
                              effect: const ExpandingDotsEffect(
                                activeDotColor: Color.fromRGBO(249, 168, 38, 1),
                                dotWidth: 10.0,
                                dotHeight: 8.0,
                                spacing: 6,
                                radius: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.01,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01),
                        children: [
                          Text(
                            '${snapshot.data[0]['name']}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_outlined),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              Expanded(
                                child: Text(
                                  '${snapshot.data[0]['address']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Text(
                            '${snapshot.data[0]['information']}',
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 20,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              const Text(
                                'Opening Time:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.5,
                                // color: Colors.black,
                              ),
                            ),
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(0.0),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${daysName[index]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                itemBuilder:
                                                    (context, index2) => Text(
                                                  '${snapshot.data[0]['timesOfWork']['${daysName[index]}'][index2]}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey
                                                        .withOpacity(0.8),
                                                  ),
                                                ),
                                                separatorBuilder:
                                                    (context, index2) =>
                                                        SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                itemCount: numOfOpeningPerDay,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  itemCount: daysName.length,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.map),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 10),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: const BorderSide(width: 1),
                              ),
                            ),
                            onPressed: () {},
                            label: const Text('View on map'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
