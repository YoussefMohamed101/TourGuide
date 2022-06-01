import 'dart:async';
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:untitled2/screens/discovery_screens/Plandetails.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/FamousPlacesDetails.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/city_descripton.dart';
import 'package:untitled2/screens/maps/DirectionsRepo.dart';
import 'package:untitled2/screens/maps/directions_model.dart';
import 'package:untitled2/screens/maps/distanceMatrix_model.dart';
import 'package:untitled2/services/GetData.dart';
import 'package:untitled2/services/location_services.dart';

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
  Direction? _info;
  Marker? origin;
  Marker? destination;
  var myMarkers = HashSet<Marker>();
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
  var cord;

  DistanceMatrix? DistanceMatrixPlaces;

  Future<void> getCityLocation() async {
    await getPlacesLocationAndSort();

    _myCameraPosition = CameraPosition(
      target: LatLng(cord[0]['city'][0]['coordinates'][0],
          cord[0]['city'][0]['coordinates'][1]),
      zoom: 11.4746,
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getPlacesLocationAndSort() async {
    cord = await getCityCoordinates(widget.cityid,widget.numberOfSights);
    DistanceMatrixPlaces = await DistanceMatrixRepo().getDistance(
        origin: cord[0]['city'][0]['coordinates'],
        destination: cord[0]['places']
    );
    for (int i = 0; i < cord[0]['places'].length; i++) {
      (cord[0]['places'][i] as Map<String, dynamic>).addAll({
        'distanceValue': DistanceMatrixPlaces!.distance[i]['distanceValue'],
        'distanceText': DistanceMatrixPlaces!.distance[i]['distanceText'],
        'durationValue': DistanceMatrixPlaces!.duration[i]['durationValue'],
        'durationText': DistanceMatrixPlaces!.duration[i]['durationText'],
      });
    }

    cord[0]['places'].sort(
            (a, b) => (a["distanceValue"]).compareTo(b["distanceValue"]) as int);

    for (var i = 0; i < cord[0]['places'].length; i++) {
      String markId = cord[0]['places'][i]['id'] as String;
      List position = cord[0]['places'][i]['coordinates'] as List;
      var infoWindow = cord[0]['places'][i]['name'];

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
    var permission = checkPermission();
    if (!permission && firstEnter) {
      getCityLocation();
      firstEnter = false;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(249, 168, 38, 1),
        title: const Text(
          'First Google Map',
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
                  polylines: {
                    if (_info != null)
                      Polyline(
                        polylineId: PolylineId('sadasd'),
                        color: Colors.red,
                        width: 5,
                        points: _info!.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),
                  },
                  markers: myMarkers,
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.30,
                  minChildSize: 0.25,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Plandetails(placeName: cord[0]['places']),
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
}
