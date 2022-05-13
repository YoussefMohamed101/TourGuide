import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled2/services/GetData.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FamousePlacesDetails extends StatefulWidget {
  @override
  State<FamousePlacesDetails> createState() => _FamousePlacesDetailsState();
}

class _FamousePlacesDetailsState extends State<FamousePlacesDetails> {
  int active = 0;
  @override
  Widget build(BuildContext context) {
    var placeInfo = (ModalRoute.of(context)!.settings.arguments as Map);
    var numOfopeningPerDay = placeInfo['timesOfWork']['Sunday'].length;
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
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.35,
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: placeInfo['img'].length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                      Container(
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider('${placeInfo['img'][itemIndex]}'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.1), BlendMode.darken),
                          ),
                        ),
                      ),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height*0.35,
                    autoPlay: true,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
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
                      count: placeInfo['img'].length,
                      effect: const ExpandingDotsEffect(
                        dotWidth:  10.0,
                        dotHeight:  8.0,
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
                    horizontal: MediaQuery.of(context).size.width * 0.01),
                children: [
                  Text(
                    '${placeInfo['name']}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    '${placeInfo['information']}',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  const Text(
                    'Opening Time:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  numOfopeningPerDay > 1
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              // color: Colors.black,
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Saturday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${placeInfo['timesOfWork']['Saturday'][0]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                            '${placeInfo['timesOfWork']['Saturday'][1]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Sunday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${placeInfo['timesOfWork']['Sunday'][0]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                            '${placeInfo['timesOfWork']['Sunday'][1]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Monday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${placeInfo['timesOfWork']['Monday'][0]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                            '${placeInfo['timesOfWork']['Monday'][1]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Tuesday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${placeInfo['timesOfWork']['Tuesday'][0]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                            '${placeInfo['timesOfWork']['Tuesday'][1]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Wednesday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${placeInfo['timesOfWork']['Wednesday'][0]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                            '${placeInfo['timesOfWork']['Wednesday'][1]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Thursday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${placeInfo['timesOfWork']['Thursday'][0]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                            '${placeInfo['timesOfWork']['Thursday'][1]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Friday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${placeInfo['timesOfWork']['Friday'][0]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(
                                            '${placeInfo['timesOfWork']['Friday'][1]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              // color: Colors.black,
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Saturday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${placeInfo['timesOfWork']['Saturday'][0]}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Sunday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${placeInfo['timesOfWork']['Sunday'][0]}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Monday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${placeInfo['timesOfWork']['Monday'][0]}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Tuesday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${placeInfo['timesOfWork']['Tuesday'][0]}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Wednesday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${placeInfo['timesOfWork']['Wednesday'][0]}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Thursday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${placeInfo['timesOfWork']['Thursday'][0]}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Friday',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${placeInfo['timesOfWork']['Friday'][0]}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 10),
                            primary: const Color.fromRGBO(249, 168, 38, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Add to plan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 10),
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: const BorderSide(width: 1),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('View on map'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
