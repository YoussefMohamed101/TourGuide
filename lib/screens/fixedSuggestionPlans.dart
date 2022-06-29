import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:label_marker/label_marker.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:untitled2/auth/secrets.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/FamousPlacesDetails.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/city_descripton.dart';
import 'package:untitled2/screens/maps/DirectionsRepo.dart';
import 'package:untitled2/screens/maps/directions_model.dart';
import 'package:untitled2/screens/maps/distanceMatrix_model.dart';
import 'package:untitled2/services/GetData.dart';
import 'package:untitled2/services/location_services.dart';
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;
import 'dart:typed_data';

class fixedSuggestionPlans extends StatefulWidget {

  fixedSuggestionPlans({
    Key? key,
    required this.planDetail,
  }) : super(key: key);

  var planDetail;

  @override
  State<fixedSuggestionPlans> createState() => _fixedSuggestionPlansState();
}

class _fixedSuggestionPlansState extends State<fixedSuggestionPlans>
    with WidgetsBindingObserver {

  var myMarkers = Set<Marker>();
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _myCameraPosition;
  bool isLoading = true;
  int activeStep = 0;
  double _containerHeight = 255.0;
  int _itemsCount = 3;
  int hour = 6;
  List data = [];
  var saved = 0;

  Future<void> getCityLocation() async {
    data = [];
    for(int i = 1; i<= widget.planDetail['places'].length; i ++){
      for(int j = 0; j < widget.planDetail['places']['$i']['ids'].length; j++){
        var dataTemp = await getPlacedata([widget.planDetail['places']['$i']['ids'][j],widget.planDetail['id']]);
        data.addAll(dataTemp);
      }
    }

    for(int i = 1; i<= widget.planDetail['places'].length; i ++){
      for(int j = 0; j < widget.planDetail['places']['$i']['ids'].length; j++){
        var dataTemp = await getPlacedata([widget.planDetail['places']['$i']['ids'][j],widget.planDetail['id']]);
        (widget.planDetail['places']['$i'] as Map<String, dynamic>).addAll({
          'place ${j+1}':dataTemp
        });
      }
    }

    for(int i = 0; i< data.length; i++){

        String markId = data[i]['id'] as String;
        List position = data[i]['coordinates'] as List;
        var infoWindow = data[i]['name'];

        myMarkers.addLabelMarker(LabelMarker(
          label: infoWindow,
          markerId: MarkerId(markId),
          position: LatLng(position[0]-0.00002, position[1]),
          backgroundColor: Colors.white,
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 20
          ),
        ));

        myMarkers.add(
          Marker(
            icon: await MarkerIcon.downloadResizePictureCircle(
                '${data[i]['img'][0]}',
                size: 150,
                addBorder: true,
                borderColor: Colors.white,
                borderSize: 15
            ),
            markerId: MarkerId(markId),
            position: LatLng(position[0], position[1]),
          ),
        );
    }

    // for (var i = 0; i < widget.planDetail['places'].length; i++) {
    //   String markId = widget.planDetail['places'][i]['id'] as String;
    //   List position = widget.planDetail['places'][i]['coordinates'] as List;
    //   var infoWindow = widget.planDetail['places'][i]['name'];
    //
    //   myMarkers.addLabelMarker(LabelMarker(
    //     label: widget.planDetail['plases'][i]['name'],
    //     markerId: MarkerId(markId),
    //     position: LatLng(widget.planDetail['plases'][i]['coordinates'][0]-0.00002, widget.planDetail['plases'][i]['coordinates'][1]),
    //     backgroundColor: Colors.white,
    //     textStyle: TextStyle(
    //         color: Colors.black,
    //         fontSize: 20
    //     ),
    //   ));
    //
    //   myMarkers.add(
    //     Marker(
    //       icon: await MarkerIcon.downloadResizePictureCircle(
    //           '${widget.planDetail['places'][i]['img']}',
    //           size: 150,
    //           addBorder: true,
    //           borderColor: Colors.white,
    //           borderSize: 15
    //       ),
    //       markerId: MarkerId(markId),
    //       position: LatLng(position[0], position[1]),
    //     ),
    //   );
    // }

    _myCameraPosition = CameraPosition(
      target: LatLng(widget.planDetail['coordinates'][0],
          widget.planDetail['coordinates'][1]),
      zoom: 11.4746,
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<void> checkSavePlan() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userdata23[4])
        .collection('userPlans').where('planID',isEqualTo: '${widget.planDetail['planID']}')
        .get().then((value) {
          saved = value.docs.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getCityLocation();
    checkSavePlan();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              PlacesList = [];
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 45,
            )),
        backgroundColor: const Color.fromRGBO(249, 168, 38, 1),
        title: const Text(
          'Suggested plan',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading == false
          ? Stack(
        fit: StackFit.expand,
        children: [
          GoogleMap(
            mapToolbarEnabled: false,
            rotateGesturesEnabled: true,
            zoomControlsEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _myCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: myMarkers,
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.30,
            minChildSize: 0.25,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: PlanDetails(),
              );
            },
          ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(249, 168, 38, 1),
        ),
      ),
    );
  }

  Widget PlanDetails(){
    _itemsCount = (data.length / widget.planDetail['places'].length).toInt();
    hour = 6;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
          AssetImage('lib/img/pexels-mostafa-el-shershaby-3772630.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3), BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.02,
                  left: MediaQuery.of(context).size.width*0.4,
                  right: MediaQuery.of(context).size.width*0.4,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: 5,
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index2) {
                    hour = 6;
                    return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0,
                            top: 10
                        ),
                        child: Text(
                            'Day ${index2+1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: _itemsCount * (_containerHeight+_itemsCount+80),
                            child: ImageStepper(

                              lineColor: Colors.white,
                              lineLength: 310,
                              lineDotRadius: 3,
                              enableNextPreviousButtons: false,
                              steppingEnabled: false,
                              stepReachedAnimationEffect: Curves.ease,
                              scrollingDisabled: true,
                              images: numberOfSteps(index2),
                              //activeStep property set to activeStep variable defined above.
                              activeStep: activeStep,
                              // This ensures step-tapping updates the activeStep.
                              onStepReached: (index) {
                                setState(() {
                                  activeStep = index;
                                });
                              },
                              direction: Axis.vertical,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40.0),
                              child: ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  hour +=2;
                                  return Container(
                                    width: double.infinity,
                                    height: _containerHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            hour > 11?
                                            hour == 12?
                                            '${hour}:00 PM -- ${widget.planDetail['places']['${index2+1}']['place ${index+1}'][0]['name']}':
                                            '${hour-12}:00 PM -- ${widget.planDetail['places']['${index2+1}']['place ${index+1}'][0]['name']}':
                                            '${hour}:00 AM -- ${widget.planDetail['places']['${index2+1}']['place ${index+1}'][0]['name']}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Visit Duration: 2 hour',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${widget.planDetail['places']['${index2+1}']['place ${index+1}'][0]['information']}',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.black,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const FamousePlacesDetails(),
                                                      settings: RouteSettings(
                                                          arguments: [
                                                            widget.planDetail['places']['${index2+1}']['place ${index+1}'][0]['id'],
                                                            widget.planDetail['id'],
                                                          ]
                                                      ),
                                                    ));
                                              },
                                              child: Text('Read more'),
                                              style: ElevatedButton.styleFrom(
                                                onPrimary: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(20.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => Container(
                                  height: MediaQuery.of(context).size.height*0.12,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                      // Container(
                                      //   height: 2,
                                      //   width: 200,
                                      //   color: Colors.white,
                                      // ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            widget.planDetail['places']['${index2+1}']['Used'][index] == 'car'?
                                            Icon(
                                              Icons.directions_car_rounded,
                                              color: Colors.white,
                                            ):Icon(
                                              Icons.directions_walk,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'After ${widget.planDetail['places']['${index2+1}']['distance']['text'][index]}, ${widget.planDetail['places']['${index2+1}']['duration']['text'][index]}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Container(
                                      //   height: 2,
                                      //   width: 200,
                                      //   color: Colors.white,
                                      // ),
                                      Container(
                                        height: 20,
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),

                                ),
                                itemCount: _itemsCount,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                  },
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        Container(
                          color: Colors.white,
                          height: 3,
                          width: double.infinity,
                        ),
                        SizedBox(height: 15,),
                      ],
                    ),
                  ),
                  itemCount: widget.planDetail['places'].length),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    // totalDistance.add('0');
                    // totalDuration.add('0');
                    // List name = [];
                    // List id= [];
                    // List cityId = [];
                    // List coordinates = [];
                    // List img = [];
                    // List information = [];
                    // List distanceValue= [];
                    // List distanceText = [];
                    // List durationValue = [];
                    // List durationText = [];
                    // List workingTime = [];

                    // for(int i = 0; i< limitCityNPlacesDetails.length;i++){
                    //   name.add(limitCityNPlacesDetails[i]['name']);
                    //   id.add(limitCityNPlacesDetails[i]['id']);
                    //   cityId.add(limitCityNPlacesDetails[i]['cityID']);
                    //   coordinates.add('${limitCityNPlacesDetails[i]['coordinates'][0]} ${limitCityNPlacesDetails[i]['coordinates'][1]}');
                    //   img.add(limitCityNPlacesDetails[i]['img']);
                    //   information.add(limitCityNPlacesDetails[i]['information']);
                    //   // distanceValue.add(limitCityNPlacesDetails[i]['distanceValue']);
                    //   distanceText.add(totalDistance[i]);
                    //   // durationValue.add(limitCityNPlacesDetails[i]['durationValue']);
                    //   durationText.add(totalDuration[i]);
                    //   workingTime.add('${limitCityNPlacesDetails[i]['workingTime'][0]} ${limitCityNPlacesDetails[i]['workingTime'][1]}');
                    // }
                    // print(coordinates);
                    // await FirebaseFirestore.instance.collection("plans").doc().set(
                    //     {
                    //       "name": name,
                    //       "id": id,
                    //       "cityId": cityId,
                    //       "coordinates": coordinates,
                    //       "img": img,
                    //       "information": information,
                    //       "distanceValue": distanceValue,
                    //       "distanceText": distanceText,
                    //       "durationValue": durationValue,
                    //       "durationText": durationText,
                    //       "workingTime": workingTime,
                    //       "userID" : FirebaseAuth.instance.currentUser!.uid,
                    //     });


                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const FamousePlacesDetails(),
                    //       settings: RouteSettings(
                    //           arguments: [
                    //             limitCityNPlacesDetails[index]['id'],
                    //             limitCityNPlacesDetails[index]['cityID'],
                    //           ]
                    //       ),
                    //     ));

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userdata23[4])
                        .collection('userPlans').where('planID',isEqualTo: '${widget.planDetail['planID']}')
                        .get()
                        .then((value) async {
                          saved = value.docs.length;
                          if(value.docs.length != 0 ){
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Plan already saved'),
                                content: Text('the plan is already saved, u can access it in Profile => My plans'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {

                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                          else{
                            var user = FirebaseAuth.instance.currentUser;
                            await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('userPlans').add(
                              {
                                'title': widget.planDetail['title'],
                                'imgUrl': widget.planDetail['imgUrl'],
                                'id': widget.planDetail['id'],
                                'planID': widget.planDetail['planID'],
                                'UserID': user.uid,
                                'Generated': 'false'
                              }
                            ).then((value) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Plan Saved successfully'),
                                  content: Text('the plan saved successfully, u can access it in Profile => My plans'),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {

                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).catchError((err) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Saving failed'),
                                  content: Text('the plan not saved, try again later'),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {

                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });

                            setState(() {
                              checkSavePlan();
                            });
                          }

                    });




                  },
                  child: saved == 0 ?Text('Save plan',
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ):Text('Saved',
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  style: saved == 0 ?ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(5.0),
                    ),
                  ):
                  ElevatedButton.styleFrom(
                    onPrimary: Color.fromRGBO(
                        249, 168, 38, 1),
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ImageProvider<dynamic>> numberOfSteps(var index2) {
    List<ImageProvider<dynamic>> li = [];

    for (int i = 0; i < _itemsCount; i++) {
      li.add(
        CachedNetworkImageProvider('${widget.planDetail['places']['${index2+1}']['place ${i+1}'][0]['img'][0]}'),
      );
    }
    return li;
  }
}
