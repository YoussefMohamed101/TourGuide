import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:math';
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

class suggestionPlanMap extends StatefulWidget {
  suggestionPlanMap({
    Key? key,
    required this.savedPlan,
    required this.planName,
    required this.cityid,
    required this.numberOfSights,
    required this.numofDays,
    required this.day,
    required this.SortType,
    required this.StartPoint,
    required this.pickedPlaces,
  }) : super(key: key);

  final bool savedPlan;
  final String planName;
  final String cityid;
  var numberOfSights;
  var day;
  var numofDays;
  String SortType;
  String StartPoint;
  String pickedPlaces;

  @override
  State<suggestionPlanMap> createState() => _suggestionPlanMapState();
}

class _suggestionPlanMapState extends State<suggestionPlanMap>
    with WidgetsBindingObserver {
  bool firstEnter = true;
  Marker? origin;
  Marker? destination;
  List<Direction> _info = [];
  var myMarkers = Set<Marker>();
  Set<Polyline> PolyLines = {};
  bool showLocationButton = true;
  bool showGetDirection = false;
  bool showDistanceAndDuration = false;
  final TextEditingController searchText = TextEditingController();
  var searchResult;
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _myCameraPosition;
  static CameraPosition? _polylineCameraPosition;
  List filterResult = [];
  bool isLoading = true;
  var cityNPlacesDetails;
  List limitCityNPlacesDetails = [];
  int activeStep = 0;
  double _containerHeight = 255.0;
  int _itemsCount1 = 3;
  List hour = [8,10,12];
  List totalDistance = [];
  List totalDuration = [];
  DistanceMatrix? DistanceMatrixPlaces;
  List designedData = [];
  bool saved = false;
  bool showSavePlanButton = true;


  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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
    if (widget.pickedPlaces == 'Choose Places') {
      cityNPlacesDetails = await getCityCoordinates(widget.cityid);
      print('awwwwwwwwwwwwwwwwwwwwwwww');
      limitCityNPlacesDetails = [];
      DistanceMatrixPlaces = await DistanceMatrixRepo().getDistance(
          origin: (widget.StartPoint == 'Simulate your are in the City')
              ? cityNPlacesDetails[0]['city'][0]['coordinates']
              : [position!.latitude, position!.longitude],
          destination: PlacesList);
      for (int i = 0; i < PlacesList.length; i++) {
        (PlacesList[i] as Map<String, dynamic>).addAll({
          'distanceValue': DistanceMatrixPlaces!.distance[i]['distanceValue'],
          'distanceText': DistanceMatrixPlaces!.distance[i]['distanceText'],
          'durationValue': DistanceMatrixPlaces!.duration[i]['durationValue'],
          'durationText': DistanceMatrixPlaces!.duration[i]['durationText'],
          'workingTime': getTime(PlacesList[i]['timesOfWork']['${widget.day}'])
        });
        PlacesList[i].remove('timesOfWork');
      }

      limitCityNPlacesDetails = PlacesList;
      print(limitCityNPlacesDetails);
    } else {
      cityNPlacesDetails = await getCityCoordinates(widget.cityid);
      cityNPlacesDetails[0]['places']..shuffle();
      limitCityNPlacesDetails = [];

      DistanceMatrixPlaces = await DistanceMatrixRepo().getDistance(
          origin: (widget.StartPoint == 'Simulate your are in the City')
              ? cityNPlacesDetails[0]['city'][0]['coordinates']
              : [position!.latitude, position!.longitude],
          destination: cityNPlacesDetails[0]['places']);
      for (int i = 0; i < cityNPlacesDetails[0]['places'].length; i++) {
        (cityNPlacesDetails[0]['places'][i] as Map<String, dynamic>).addAll({
          'distanceValue': DistanceMatrixPlaces!.distance[i]['distanceValue'],
          'distanceText': DistanceMatrixPlaces!.distance[i]['distanceText'],
          'durationValue': DistanceMatrixPlaces!.duration[i]['durationValue'],
          'durationText': DistanceMatrixPlaces!.duration[i]['durationText'],
          'workingTime': getTime(cityNPlacesDetails[0]['places'][i]
          ['timesOfWork']['${widget.day}'])
        });
        cityNPlacesDetails[0]['places'][i].remove('timesOfWork');
      }

      if (cityNPlacesDetails[0]['places'].length < widget.numberOfSights) {
        for (int i = 0; i < cityNPlacesDetails[0]['places'].length; i++) {
          if (cityNPlacesDetails[0]['places'][i]['workingTime'][0] != '0') {
            limitCityNPlacesDetails
                .addAll({cityNPlacesDetails[0]['places'][i]});
          }
        }
      } else {
        for (int i = 0; i < widget.numberOfSights; i++) {
          if (cityNPlacesDetails[0]['places'][i]['workingTime'][0] != '0') {
            limitCityNPlacesDetails
                .addAll({cityNPlacesDetails[0]['places'][i]});
          }
        }
      }
    }

  }

  List getTime(var str) {
    String str2 = '';
    List numberOnly = [];

    if (str.toString().toLowerCase() == 'closed') {
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

    for (var i = 1; i < numberOnly.length; i += 1) {
      numberOnly.removeAt(i);
    }
    print(numberOnly);
    return numberOnly;
  }

  Future<void> SortPlacesByDistanceAndOpeningTime() async {
    await getPlacesLocationAndShuffle();
    if (widget.SortType == 'Distance') {
      limitCityNPlacesDetails.sort(
              (a, b) => (a["distanceValue"]).compareTo(b["distanceValue"]) as int);
    } else if (widget.SortType == 'Duration') {
      limitCityNPlacesDetails.sort((a, b) => (int.parse(a["workingTime"][0]))
          .compareTo(int.parse(b["workingTime"][0])) as int);
    } else {
      limitCityNPlacesDetails.sort(
              (a, b) => (a["distanceValue"]).compareTo(b["distanceValue"]) as int);
      limitCityNPlacesDetails.sort((a, b) => (int.parse(a["workingTime"][0]))
          .compareTo(int.parse(b["workingTime"][0])) as int);
    }

    for (var i = 0; i < limitCityNPlacesDetails.length; i++) {
      String markId = limitCityNPlacesDetails[i]['id'] as String;
      List position = limitCityNPlacesDetails[i]['coordinates'] as List;
      var infoWindow = limitCityNPlacesDetails[i]['name'];

      myMarkers.addLabelMarker(LabelMarker(
        label: limitCityNPlacesDetails[i]['name'],
        markerId: MarkerId(markId),
        position: LatLng(limitCityNPlacesDetails[i]['coordinates'][0] - 0.00002,
            limitCityNPlacesDetails[i]['coordinates'][1]),
        backgroundColor: Colors.white,
        textStyle: TextStyle(color: Colors.black, fontSize: 20),
      ));

      myMarkers.add(
        Marker(
          icon: await MarkerIcon.downloadResizePictureCircle(
              '${limitCityNPlacesDetails[i]['img']}',
              size: 150,
              addBorder: true,
              borderColor: Colors.white,
              borderSize: 15),
          markerId: MarkerId(markId),
          position: LatLng(position[0], position[1]),
        ),
      );
    }

    for (var i = 0; i < limitCityNPlacesDetails.length - 1; i++) {
      final direction = await DirectionsRepo().getDirections(
          origin: LatLng(limitCityNPlacesDetails[i]['coordinates'][0],
              limitCityNPlacesDetails[i]['coordinates'][1]),
          destination: LatLng(limitCityNPlacesDetails[i + 1]['coordinates'][0],
              limitCityNPlacesDetails[i + 1]['coordinates'][1]));
      _info.add(
        direction,
      );
    }

    for (var i = 0; i < limitCityNPlacesDetails.length - 1; i++) {
      totalDistance.add(
        _info[i].totalDistance,
      );
      totalDuration.add(
        _info[i].totalDuration,
      );
    }

    totalDistance.add(
      0,
    );
    totalDuration.add(
      0,
    );



    designedData = [];
    for (int i = 0; i< limitCityNPlacesDetails.length; i+=1){
      designedData.add({
        'duration': '${totalDuration[i]}',
        'distance': '${totalDistance[i]}',
        'Place 1': {
          'id' : limitCityNPlacesDetails[i]['id'],
          'img' : limitCityNPlacesDetails[i]['img'],
          'name' : limitCityNPlacesDetails[i]['name'],
          'information' : limitCityNPlacesDetails[i]['information'],
          'coordinates' : limitCityNPlacesDetails[i]['coordinates'],
        },
        'coordinates': [30.00935956528337, 31.199082360667852],
        'id': widget.cityid,
      });
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

  Future<void> getSavedData() async {
    designedData = await showGeneratedPlanDetails(widget.planName,userdata23[4]);
    cityNPlacesDetails = await getCityCoordinates(designedData[0]['id']);
    _myCameraPosition = CameraPosition(
      target: LatLng(cityNPlacesDetails[0]['city'][0]['coordinates'][0],
          cityNPlacesDetails[0]['city'][0]['coordinates'][1]),
      zoom: 11.4746,
    );
    for (var i = 0; i < designedData.length; i++) {
      String markId = designedData[i]['Place 1']['id'] as String;
      List position = designedData[i]['Place 1']['coordinates'] as List;
      var infoWindow = designedData[i]['Place 1']['name'];

      myMarkers.addLabelMarker(LabelMarker(
        label: infoWindow,
        markerId: MarkerId(markId),
        position: LatLng(position[0] - 0.00002,
            position[1]),
        backgroundColor: Colors.white,
        textStyle: TextStyle(color: Colors.black, fontSize: 20),
      ));

      myMarkers.add(
        Marker(
          icon: await MarkerIcon.downloadResizePictureCircle(
              '${designedData[i]['Place 1']['img']}',
              size: 150,
              addBorder: true,
              borderColor: Colors.white,
              borderSize: 15),
          markerId: MarkerId(markId),
          position: LatLng(position[0], position[1]),
        ),
      );
    }
    showSavePlanButton =false;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    if(widget.savedPlan == false) {
      if (checkPermission()) {
        getCityLocation();
      }
    }
    else{
      if (checkPermission()) {
        getSavedData();
      }
    }
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
        // firstEnter = true;
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

  Future<void> getPermission() async {
    var position = await LocationService.determinePosition();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var permission = checkPermission();
    return WillPopScope(
      onWillPop: () async {
        PlacesList = [];
        Navigator.of(context).popUntil((route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                PlacesList = [];
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
                size: 45,
              )),
          backgroundColor: const Color.fromRGBO(249, 168, 38, 1),
          title: const Text(
            'Generated plan',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: permission == true
            ? isLoading == false
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
              builder: (BuildContext context,
                  ScrollController scrollController) {
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
        )
            : Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Location service is denied pls change it in settings'),
              ElevatedButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                  },
                  child: const Text('press')),
              const Text('After u opened setting, Press refresh'),
              ElevatedButton(
                  onPressed: () async {
                    await getPermission();
                    if (checkPermission()) {
                      await getCityLocation();
                    }
                    setState(() {});
                  },
                  child: const Text('Refresh')),
            ],
          ),
        ),
      ),
    );
  }

  Widget PlanDetails() {
    // _itemsCount = limitCityNPlacesDetails.length~/designedData.length;
    _itemsCount1 = 3;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/img/pexels-mostafa-el-shershaby-3772630.png'),
          fit: BoxFit.cover,
          colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
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
                  top: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.width * 0.4,
                  right: MediaQuery.of(context).size.width * 0.4,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: 5,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  designedData.length > 3?
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 10
                    ),
                    child: Text(
                      'Day 1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ):Container(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: designedData.length < 3? designedData.length * (_containerHeight + designedData.length + 80):_itemsCount1 * (_containerHeight + _itemsCount1 + 80),
                        child: ImageStepper(
                          lineColor: Colors.white,
                          lineLength: 310,
                          lineDotRadius: 3,
                          enableNextPreviousButtons: false,
                          steppingEnabled: false,
                          stepReachedAnimationEffect: Curves.ease,
                          scrollingDisabled: true,
                          images: designedData.length < 3? numberOfSteps(0,designedData.length):numberOfSteps(0,_itemsCount1),
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hour[index] == 12?
                                        '${hour[index]}:00 PM -- ${designedData[index]['Place 1']['name']}':
                                        '${hour[index]}:00 AM -- ${designedData[index]['Place 1']['name']}',
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
                                        '${designedData[index]['Place 1']['information']}',
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
                                                  builder: (context) =>
                                                  const FamousePlacesDetails(),
                                                  settings:
                                                  RouteSettings(arguments: [
                                                    designedData[index]['Place 1']['id'],
                                                    cityNPlacesDetails[0]['city'][0]
                                                    ['id'],
                                                  ]),
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
                              height: MediaQuery.of(context).size.height * 0.12,
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
                                            'After ${designedData[index]['distance']},${designedData[index]['duration']}',
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
                            itemCount: designedData.length < 3? designedData.length:_itemsCount1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  designedData.length > 3?
                  Padding(
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
                  ):Container(),
                  designedData.length > 3?
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 10
                    ),
                    child: Text(
                      'Day 2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ):Container(),
                  designedData.length > 3?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: designedData.length > 6? (_itemsCount1) * (_containerHeight + (_itemsCount1) + 80)
                        :(designedData.length - _itemsCount1) * (_containerHeight + (designedData.length - _itemsCount1) + 80),
                        child: ImageStepper(
                          lineColor: Colors.white,
                          lineLength: 310,
                          lineDotRadius: 3,
                          enableNextPreviousButtons: false,
                          steppingEnabled: false,
                          stepReachedAnimationEffect: Curves.ease,
                          scrollingDisabled: true,
                          images: designedData.length > 6? numberOfSteps(3,_itemsCount1*2) : numberOfSteps(3,designedData.length),
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hour[index] == 12?
                                        '${hour[index]}:00 PM -- ${designedData[index+3]['Place 1']['name']}':
                                        '${hour[index]}:00 AM -- ${designedData[index+3]['Place 1']['name']}',
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
                                        '${designedData[index+3]['Place 1']['information']}',
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
                                                  builder: (context) =>
                                                  const FamousePlacesDetails(),
                                                  settings:
                                                  RouteSettings(arguments: [
                                                    limitCityNPlacesDetails[index+3]
                                                    ['id'],
                                                    cityNPlacesDetails[0]['city'][0]
                                                    ['id'],
                                                  ]),
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
                              height: MediaQuery.of(context).size.height * 0.12,
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
                                            'After ${designedData[index+3]['distance']},${designedData[index+3]['duration']}',
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
                            itemCount: designedData.length > 6? _itemsCount1 : designedData.length - _itemsCount1,
                          ),
                        ),
                      ),
                    ],
                  ):Container(),


                  designedData.length > 6?
                  Padding(
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
                  ):Container(),
                  designedData.length > 6?
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 10
                    ),
                    child: Text(
                      'Day 3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ):Container(),
                  designedData.length > 6?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: designedData.length > 9? (_itemsCount1) * (_containerHeight + (_itemsCount1) + 80)
                            :(designedData.length - _itemsCount1*2) * (_containerHeight + (designedData.length - _itemsCount1*2) + 80),
                        child: ImageStepper(
                          lineColor: Colors.white,
                          lineLength: 310,
                          lineDotRadius: 3,
                          enableNextPreviousButtons: false,
                          steppingEnabled: false,
                          stepReachedAnimationEffect: Curves.ease,
                          scrollingDisabled: true,
                          images: designedData.length > 9? numberOfSteps(6,_itemsCount1*3) : numberOfSteps(6,designedData.length),
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hour[index] == 12?
                                        '${hour[index]}:00 PM -- ${designedData[index+6]['Place 1']['name']}':
                                        '${hour[index]}:00 AM -- ${designedData[index+6]['Place 1']['name']}',
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
                                        '${designedData[index+6]['Place 1']['information']}',
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
                                                  builder: (context) =>
                                                  const FamousePlacesDetails(),
                                                  settings:
                                                  RouteSettings(arguments: [
                                                    limitCityNPlacesDetails[index+6]
                                                    ['id'],
                                                    cityNPlacesDetails[0]['city'][0]
                                                    ['id'],
                                                  ]),
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
                              height: MediaQuery.of(context).size.height * 0.12,
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
                                            'After ${designedData[index+6]['distance']},${designedData[index+6]['duration']}',
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
                            itemCount: designedData.length > 9? _itemsCount1 : designedData.length - _itemsCount1*2,
                          ),
                        ),
                      ),
                    ],
                  ):Container(),


                  designedData.length > 9?
                  Padding(
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
                  ):Container(),
                  designedData.length > 9?
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 10
                    ),
                    child: Text(
                      'Day 4',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ):Container(),
                  designedData.length > 9?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: designedData.length > 12? (_itemsCount1) * (_containerHeight + (_itemsCount1) + 80)
                            :(designedData.length - _itemsCount1*3) * (_containerHeight + (designedData.length - _itemsCount1*3) + 80),
                        child: ImageStepper(
                          lineColor: Colors.white,
                          lineLength: 310,
                          lineDotRadius: 3,
                          enableNextPreviousButtons: false,
                          steppingEnabled: false,
                          stepReachedAnimationEffect: Curves.ease,
                          scrollingDisabled: true,
                          images: designedData.length > 12? numberOfSteps(9,_itemsCount1*4) : numberOfSteps(9,designedData.length),
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hour[index] == 12?
                                        '${hour[index]}:00 PM -- ${designedData[index+9]['Place 1']['name']}':
                                        '${hour[index]}:00 AM -- ${designedData[index+9]['Place 1']['name']}',
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
                                        '${designedData[index+9]['Place 1']['information']}',
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
                                                  builder: (context) =>
                                                  const FamousePlacesDetails(),
                                                  settings:
                                                  RouteSettings(arguments: [
                                                    limitCityNPlacesDetails[index+9]
                                                    ['id'],
                                                    cityNPlacesDetails[0]['city'][0]
                                                    ['id'],
                                                  ]),
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
                              height: MediaQuery.of(context).size.height * 0.12,
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
                                            'After ${designedData[index+9]['distance']},${designedData[index+9]['duration']}',
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
                            itemCount: designedData.length > 12? _itemsCount1 : designedData.length - _itemsCount1*3,
                          ),
                        ),
                      ),
                    ],
                  ):Container(),



                  designedData.length > 12?
                  Padding(
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
                  ):Container(),
                  designedData.length > 12?
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 10
                    ),
                    child: Text(
                      'Day 5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ):Container(),
                  designedData.length > 12?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: (designedData.length - _itemsCount1*4) * (_containerHeight + (designedData.length - _itemsCount1*4) + 80),
                        child: ImageStepper(
                          lineColor: Colors.white,
                          lineLength: 310,
                          lineDotRadius: 3,
                          enableNextPreviousButtons: false,
                          steppingEnabled: false,
                          stepReachedAnimationEffect: Curves.ease,
                          scrollingDisabled: true,
                          images: numberOfSteps(12,designedData.length),
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hour[index] == 12?
                                        '${hour[index]}:00 PM -- ${designedData[index+12]['Place 1']['name']}':
                                        '${hour[index]}:00 AM -- ${designedData[index+12]['Place 1']['name']}',
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
                                        '${designedData[index+12]['Place 1']['information']}',
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
                                                  builder: (context) =>
                                                  const FamousePlacesDetails(),
                                                  settings:
                                                  RouteSettings(arguments: [
                                                    limitCityNPlacesDetails[index+12]
                                                    ['id'],
                                                    cityNPlacesDetails[0]['city'][0]
                                                    ['id'],
                                                  ]),
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
                              height: MediaQuery.of(context).size.height * 0.12,
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
                                            'After ${designedData[index+12]['distance']},${designedData[index+12]['duration']}',
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
                            itemCount: designedData.length - _itemsCount1*4,
                          ),
                        ),
                      ),
                    ],
                  ):Container(),
                ],
              ),
              Visibility(
                visible: showSavePlanButton,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      // totalDistance.add('0');
                      // totalDuration.add('0');
                      // List name = [];
                      // List id = [];
                      // List cityId = [];
                      // List coordinates = [];
                      // List img = [];
                      // List information = [];
                      // List distanceValue = [];
                      // List distanceText = [];
                      // List durationValue = [];
                      // List durationText = [];
                      // List workingTime = [];
                      // for (int i = 0; i < limitCityNPlacesDetails.length; i++) {
                      //   name.add(limitCityNPlacesDetails[i]['name']);
                      //   id.add(limitCityNPlacesDetails[i]['id']);
                      //   cityId.add(limitCityNPlacesDetails[i]['cityID']);
                      //   coordinates.add(
                      //       '${limitCityNPlacesDetails[i]['coordinates'][0]} ${limitCityNPlacesDetails[i]['coordinates'][1]}');
                      //   img.add(limitCityNPlacesDetails[i]['img']);
                      //   information
                      //       .add(limitCityNPlacesDetails[i]['information']);
                      //   // distanceValue.add(limitCityNPlacesDetails[i]['distanceValue']);
                      //   distanceText.add(totalDistance[i]);
                      //   // durationValue.add(limitCityNPlacesDetails[i]['durationValue']);
                      //   durationText.add(totalDuration[i]);
                      //   workingTime.add(
                      //       '${limitCityNPlacesDetails[i]['workingTime'][0]} ${limitCityNPlacesDetails[i]['workingTime'][1]}');
                      // }
                      // print(coordinates);

                      if(saved == false) {
                        String planId = getRandomString(20);
                        await FirebaseFirestore.instance.collection('users')
                            .doc(userdata23[4])
                            .collection('userPlans')
                        .doc(planId)
                            .set({
                          'Data': designedData,
                          "userID": userdata23[4],
                          'title': widget.planName.length != 0? widget.planName: 'Generated plan',
                          'Generated': 'true',
                          'imgUrl': designedData[0]['Place 1']['img'],
                          'planID' : planId,
                        }).then((value) {
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
                          saved = true;
                        });


                      }
                      else{
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
                    child: !saved?Text('Save plan',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ):Text('Saved',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                    style: !saved?ElevatedButton.styleFrom(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ImageProvider<dynamic>> numberOfSteps(int start,int length) {
    List<ImageProvider<dynamic>> li = [];
    for (int i = start; i < length; i++) {
      li.add(
        CachedNetworkImageProvider('${designedData[i]['Place 1']['img']}'),
      );
    }
    return li;
  }
}


