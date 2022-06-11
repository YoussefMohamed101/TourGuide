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
import 'package:untitled2/screens/discovery_screens/citiesData/FamousPlacesDetails.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/city_descripton.dart';
import 'package:untitled2/screens/maps/DirectionsRepo.dart';
import 'package:untitled2/screens/maps/directions_model.dart';
import 'package:untitled2/screens/maps/distanceMatrix_model.dart';
import 'package:untitled2/services/GetData.dart';
import 'package:untitled2/services/location_services.dart';
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;
import 'dart:typed_data';

class suggestionPlanMap extends StatefulWidget {
  suggestionPlanMap({Key? key, required this.cityid,required this.numberOfSights}) : super(key: key);

  final String cityid;
  var numberOfSights;

  @override
  State<suggestionPlanMap> createState() => _suggestionPlanMapState();
}

class _suggestionPlanMapState extends State<suggestionPlanMap>
    with WidgetsBindingObserver {
  bool firstEnter = true;
  List <Direction> _info = [];
  Marker? origin;
  Marker? destination;
  var myMarkers = Set<Marker>();
  Set<Polyline> Polylines = {};

  FloatingSearchBarController fcontroller = FloatingSearchBarController();
  bool showLocationButton = true;
  bool showGetDirection = false;
  bool showDistanceAndDuration = false;
  final TextEditingController searchText = TextEditingController();
  var searchResult;
  static Position? position;
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _myCameraPosition;
  static CameraPosition? _disCameraPosition;
  static CameraPosition? _polylineCameraPosition;
  List filterResult = [];
  bool isLoading = true;
  var cityNPlacesDetails;
  List limitCityNPlacesDetails= [];
  int activeStep = 0;
  double _containerHeight = 255.0;
  int _itemsCount = 3;
  int hour = 7;
  List totalDistance = [];
  List totalDuration = [];
  List totalPolyline = [];

  DistanceMatrix? DistanceMatrixPlaces;

  Future<void> getCityLocation() async {
    await SortPlacesByDistanceAndOpeningTime();

    _myCameraPosition = CameraPosition(
      target: LatLng(cityNPlacesDetails[0]['city'][0]['coordinates'][0],
          cityNPlacesDetails[0]['city'][0]['coordinates'][1]),
      zoom: 11.4746,
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getPlacesLocationAndShuffle() async {
    cityNPlacesDetails = await getCityCoordinates(widget.cityid);
    cityNPlacesDetails[0]['places']..shuffle();
    limitCityNPlacesDetails = [];

    DistanceMatrixPlaces = await DistanceMatrixRepo().getDistance(
        origin: cityNPlacesDetails[0]['city'][0]['coordinates'],
        destination: cityNPlacesDetails[0]['places']
    );
    for (int i = 0; i < cityNPlacesDetails[0]['places'].length; i++) {
      var date = DateTime.now();
      String dateName = DateFormat('EEEE').format(date);
      (cityNPlacesDetails[0]['places'][i] as Map<String, dynamic>).addAll({
        'distanceValue': DistanceMatrixPlaces!.distance[i]['distanceValue'],
        'distanceText': DistanceMatrixPlaces!.distance[i]['distanceText'],
        'durationValue': DistanceMatrixPlaces!.duration[i]['durationValue'],
        'durationText': DistanceMatrixPlaces!.duration[i]['durationText'],
        'workingTime' : testTime(cityNPlacesDetails[0]['places'][i]['timesOfWork']['$dateName'])
      });
      cityNPlacesDetails[0]['places'][i].remove('timesOfWork');
    }


    if(cityNPlacesDetails[0]['places'].length < widget.numberOfSights){
      for(int i = 0; i < cityNPlacesDetails[0]['places'].length; i++){
        if(cityNPlacesDetails[0]['places'][i]['workingTime'][0] != '0'){
          limitCityNPlacesDetails.addAll({
            cityNPlacesDetails[0]['places'][i]
          });
        }
      }
    }
    else{
      for(int i = 0; i < widget.numberOfSights; i++){
        if(cityNPlacesDetails[0]['places'][i]['workingTime'][0] != '0'){
          limitCityNPlacesDetails.addAll({
            cityNPlacesDetails[0]['places'][i]
          });
        }
      }
    }


  }

  List testTime(var str){

    String str2 = '';
    List numberOnly= [];

    if(str.toString().toLowerCase() == 'closed'){
      numberOnly.add('0');
      print('555555555555555555555555555555555555555555555');
      print(numberOnly);
      return numberOnly;
    }
    // if(str[0] == '24-hrs'){
    //   str2 = '24 24';
    //   str2 = str2.replaceAll(RegExp('[^0-9]'), ' ');
    //   print(str2);
    //   str2 = str2.trim();
    //   numberOnly += str2.split(RegExp(' +'));
    //   return numberOnly;
    // }


    for (var value in str) {
      str2 = value.replaceAll(RegExp('[^0-9]'), ' ');
      print(str2);
      str2 = str2.trim();
      numberOnly += str2.split(RegExp(' +'));
    }

    print(numberOnly);

    for (var i = 1;i < numberOnly.length; i+=1){
      numberOnly.removeAt(i);
    }
    print(numberOnly);
    return numberOnly;
  }

  Future<void> SortPlacesByDistanceAndOpeningTime() async {
    await getPlacesLocationAndShuffle();
    // print('//////////////////////////////////////////////////');
    // log(limitCityNPlacesDetails.toString());

    limitCityNPlacesDetails.sort(
            (a, b) => (a["distanceValue"]).compareTo(b["distanceValue"]) as int);


    limitCityNPlacesDetails.sort(
            (a, b) => (int.parse(a["workingTime"][0])).compareTo(int.parse(b["workingTime"][0])) as int);


    print('//////////////////////////////////////////////////');
    log(limitCityNPlacesDetails.toString());

    for (var i = 0; i < limitCityNPlacesDetails.length; i++) {
      String markId = limitCityNPlacesDetails[i]['id'] as String;
      List position = limitCityNPlacesDetails[i]['coordinates'] as List;
      var infoWindow = limitCityNPlacesDetails[i]['name'];

      myMarkers.addLabelMarker(LabelMarker(
        label: limitCityNPlacesDetails[i]['name'],
        markerId: MarkerId(markId),
        position: LatLng(limitCityNPlacesDetails[i]['coordinates'][0]-0.00002, limitCityNPlacesDetails[i]['coordinates'][1]),
        backgroundColor: Colors.white,
        textStyle: TextStyle(
          color: Colors.black,
          fontSize: 20
        ),
      ));

      myMarkers.add(
        Marker(
          icon: await MarkerIcon.downloadResizePictureCircle(
              '${limitCityNPlacesDetails[i]['img']}',
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

    for (var i = 0; i < limitCityNPlacesDetails.length-1; i++) {

      final direction = await DirectionsRepo().getDirections(origin: LatLng(limitCityNPlacesDetails[i]['coordinates'][0], limitCityNPlacesDetails[i]['coordinates'][1]), destination: LatLng(limitCityNPlacesDetails[i+1]['coordinates'][0], limitCityNPlacesDetails[i+1]['coordinates'][1]));
      _info.add(
        direction,
      );

    }

    List<Color> colors = [Colors.red,Colors.black,Colors.white,Colors.blue,Colors.green,Colors.cyan,Colors.deepPurple,Colors.lightGreenAccent];
    for (var i = 0; i < limitCityNPlacesDetails.length-1; i++) {
      int j = 0;
      if(i > 8){
        j++;
      }
      totalDistance.add(
        _info[i].totalDistance,
      );
      totalDuration.add(
          _info[i].totalDuration,
      );
    }
  }

  Future<void> getPlacesLocationAndSort() async {
    limitCityNPlacesDetails.sort(
            (a, b) => (a["distanceValue"]).compareTo(b["distanceValue"]) as int);

    log(limitCityNPlacesDetails.toString());
    for (var i = 0; i < limitCityNPlacesDetails.length; i++) {
      String markId = limitCityNPlacesDetails[i]['id'] as String;
      List position = limitCityNPlacesDetails[i]['coordinates'] as List;
      var infoWindow = limitCityNPlacesDetails[i]['name'];

      myMarkers.add(
        Marker(
            markerId: MarkerId(markId),
            position: LatLng(position[0], position[1]),
            infoWindow: InfoWindow(
              title: infoWindow,
            )),
      );
    }
  }

  Future<void> polylineCamera() async {
    var center = [
      (origin!.position.latitude + destination!.position.latitude) / 2,
      (origin!.position.longitude + destination!.position.longitude) / 2,
    ];
    print(center);
    _polylineCameraPosition = CameraPosition(
      target: LatLng(center[0], center[1]),
      zoom: 7.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_polylineCameraPosition!));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getCityLocation();
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
        firstEnter = true;
      });
    }
  }

  bool checkPermission() {
    if (LocationService.permission == LocationPermission.denied) {
      return false;
    } else if (LocationService.permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('88888888888888888888888888888888888888888');
    // print(totalDistance);
    // print(totalDuration);
    // for(int i=0;i< 3;i++){
    //   log(limitCityNPlacesDetails[i]['workingTime'].toString());
    //   log(limitCityNPlacesDetails[i]['name'].toString());
    //   log(limitCityNPlacesDetails[i]['durationText'].toString());
    // }
    // log(limitCityNPlacesDetails[0].toString());
    var permission = checkPermission();
    if (!permission && firstEnter) {
      getCityLocation();
      firstEnter = false;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
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
                  // polylines: Polylines,
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
    _itemsCount = limitCityNPlacesDetails.length;
    hour = 7;
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
                      images: numberOfSteps(),
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
                                    hour > 12?
                                    '${hour-12}:00 PM -- ${limitCityNPlacesDetails[index]['name']}':
                                    '${hour}:00 AM -- ${limitCityNPlacesDetails[index]['name']}',
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
                                    '${limitCityNPlacesDetails[index]['information']}',
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
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(Icons
                                                .arrow_circle_right_outlined),
                                            Text('Add'),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(Icons.access_time_outlined),
                                            Text('Open'),
                                          ],
                                        ),
                                      ],
                                    ),
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
                                                    limitCityNPlacesDetails[index]['id'],
                                                    limitCityNPlacesDetails[index]['cityID'],
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
                                    Icon(
                                      Icons.directions_car_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                          'After ${totalDistance[index]},${totalDuration[index]}',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    List name = [];
                    List id= [];
                    List cityId = [];
                    List coordinates = [];
                    List img = [];
                    List information = [];
                    List distanceValue= [];
                    List distanceText = [];
                    List durationValue = [];
                    List durationText = [];
                    List workingTime = [];
                    for(int i = 0; i< limitCityNPlacesDetails.length;i++){
                      name.add(limitCityNPlacesDetails[i]['name']);
                      id.add(limitCityNPlacesDetails[i]['id']);
                      cityId.add(limitCityNPlacesDetails[i]['cityID']);
                      coordinates.add('${limitCityNPlacesDetails[i]['coordinates'][0]} ${limitCityNPlacesDetails[i]['coordinates'][1]}');
                      img.add(limitCityNPlacesDetails[i]['img']);
                      information.add(limitCityNPlacesDetails[i]['information']);
                      distanceValue.add(limitCityNPlacesDetails[i]['distanceValue']);
                      distanceText.add(limitCityNPlacesDetails[i]['distanceText']);
                      durationValue.add(limitCityNPlacesDetails[i]['durationValue']);
                      durationText.add(limitCityNPlacesDetails[i]['durationText']);
                      workingTime.add(limitCityNPlacesDetails[i]['workingTime']);
                    }
                    print(coordinates);
                    await FirebaseFirestore.instance.collection("plans").doc().set(
                        {
                          "name": name,
                          "id": id,
                          "cityId": cityId,
                          "coordinates": coordinates,
                          "img": img,
                          "information": information,
                          "distanceValue": distanceValue,
                          "distanceText": distanceText,
                          "durationValue": durationValue,
                          "durationText": durationText,
                          "workingTime": durationText,
                          "userID" : FirebaseAuth.instance.currentUser!.uid,
                        });


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
                  },
                  child: Text('Save plan',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
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

  List<ImageProvider<dynamic>> numberOfSteps() {
    List<ImageProvider<dynamic>> li = [];
    for (int i = 0; i < _itemsCount; i++) {
      li.add(
        CachedNetworkImageProvider('${limitCityNPlacesDetails[i]['img']}'),
      );
    }
    return li;
  }
}
