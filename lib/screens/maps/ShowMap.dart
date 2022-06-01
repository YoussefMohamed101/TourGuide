import 'dart:async';
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/FamousPlacesDetails.dart';
import 'package:untitled2/screens/discovery_screens/citiesData/city_descripton.dart';
import 'package:untitled2/screens/maps/DirectionsRepo.dart';
import 'package:untitled2/screens/maps/directions_model.dart';
import 'package:untitled2/services/GetData.dart';
import 'package:untitled2/services/location_services.dart';

class Show_Maps extends StatefulWidget {
  const Show_Maps({Key? key}) : super(key: key);

  @override
  State<Show_Maps> createState() => _Show_MapsState();
}

class _Show_MapsState extends State<Show_Maps> with WidgetsBindingObserver {
  bool firstEnter = true;
  Direction? _info;
  Marker? origin;
  Marker? destination;
  FloatingSearchBarController fcontroller = FloatingSearchBarController();
  bool showLocationButton = true;
  bool showGetDirection = false;
  bool showDistanceAndDuration = false;
  final TextEditingController searchText = TextEditingController();
  var searchResult;
  static Position? position;
  final Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _myCameraPosition = CameraPosition(
    target: LatLng(position!.latitude, position!.longitude),
    zoom: 16.4746,
  );
  static CameraPosition? _disCameraPosition;
  static CameraPosition? _polylineCameraPosition;
  List filterResult = [];

  Future<void> getMylastLocation() async {
    position = await LocationService.getLastKnownPosition();
    if (position != null) {
      setState(() {});
    }
  }

  Future<void> getMyLocation() async {
    position = await LocationService.determinePosition();
    if (position != null) {
      setState(() {});
    }
  }

  Future<void> goToMyCurrLocation() async {
    getMyLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myCameraPosition));
  }

  void buildDestinationCamera(var postion) {
    _disCameraPosition = CameraPosition(
      target: LatLng(postion[0], postion[1]),
      zoom: 16.4746,
    );
  }

  Future<void> goTodisLocation(var postion) async {
    buildDestinationCamera(postion);
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_disCameraPosition!));
  }

  Future<void> polylineCamera() async {
    var center = [
      (origin!.position.latitude + destination!.position.latitude)/2,
      (origin!.position.longitude + destination!.position.longitude)/2,
    ];
    print(center);
    _polylineCameraPosition = CameraPosition(
      target: LatLng(center[0], center[1]),
      zoom: 7.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_polylineCameraPosition!));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getMylastLocation();
    if (position == null) {
      getMyLocation();
    }
    searchResult = searchEngine();
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
      getMyLocation();
      firstEnter = false;
    }
    filterResult = [];
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
      body: FutureBuilder(
          future: searchResult,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data.length; i++) {
                if (snapshot.data[i]['name'].toString().length <
                    searchText.text.length) {
                  continue;
                }
                if (snapshot.data[i]['name']
                        .toString()
                        .toLowerCase()
                        .substring(0, searchText.text.length) ==
                    searchText.text.toLowerCase()) {
                  filterResult.add({
                    'id': snapshot.data[i]['id'],
                    'name': snapshot.data[i]['name'],
                    'cityID': snapshot.data[i]['cityID'],
                    'coordinates': snapshot.data[i]['coordinates'],
                  });
                }
              }
              return Stack(
                fit: StackFit.expand,
                children: [
                  position != null
                      ? GoogleMap(
                          mapToolbarEnabled: false,
                          rotateGesturesEnabled: true,
                          zoomControlsEnabled: false,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          mapType: MapType.normal,
                          initialCameraPosition: _myCameraPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                    polylines: {
                            if(_info != null)
                              Polyline(
                                polylineId: PolylineId('sadasd'),
                                color: Colors.red,
                                width: 5,
                                points: _info!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                              ),
                    },
                          markers: {
                            if (origin != null) origin!,
                            if (destination != null) destination!,
                          },
                        )
                      : permission == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color.fromRGBO(249, 168, 38, 1),
                              ),
                            )
                          : Column(
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
                              ],
                            ),
                  buildFloatingSearchBar(),
                  Visibility(
                    visible: showGetDirection,
                    child: Align(
                      alignment: Alignment(0,0.5),
                      child: ElevatedButton(onPressed: () async {
                        showGetDirection = false;
                        final direction;
                        if(origin != null && destination != null){
                          direction = await DirectionsRepo().getDirections(origin: origin!.position, destination: destination!.position);
                        }
                        else {
                          direction = null;
                        }
                        await polylineCamera();
                        setState(() {
                          _info = direction;
                        });
            }, child: Text('Get Direction')),
                    ),
                  ),
                  if(_info != null)
                    Visibility(
                      visible: showDistanceAndDuration,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 80.0
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.yellowAccent,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 6.0,
                                )
                              ],
                            ),
                            child: Text(
                              '${_info!.totalDistance}, ${_info!.totalDuration}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: Visibility(
        visible: showLocationButton,
        child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(249, 168, 38, 1.0),
          onPressed: () => goToMyCurrLocation(),
          child: const Icon(Icons.gps_fixed),
        ),
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: fcontroller,
      onFocusChanged: (isFocused) {
        if (isFocused) {
          showLocationButton = false;
          showDistanceAndDuration = false;
          showGetDirection = false;
        } else {
          showLocationButton = true;
          showDistanceAndDuration = true;
          if(origin != null && destination != null){
            showGetDirection = true;
          }
        }
        setState(() {});
      },
      automaticallyImplyDrawerHamburger: false,
      automaticallyImplyBackButton: false,
      hint: 'Search...',
      elevation: 6,
      hintStyle: const TextStyle(fontSize: 18),
      queryStyle: const TextStyle(fontSize: 18),
      //padding: EdgeInsets.all(8),
      margins: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(10),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 50),
      transitionDuration: const Duration(milliseconds: 350),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : 0.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 350 : 600,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        searchText.text = query;
        setState(() {});
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: true,
          color: const Color.fromRGBO(249, 168, 38, 1),
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white.withOpacity(0.9),
            elevation: 4.0,
            child: Column(
              children: [
                SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0.0),
                    //scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.045,
                          child: Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.grey,
                                        size: 30,
                                        // color: Color.fromRGBO(249, 168, 38, 1),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${filterResult[index]['name']}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox.expand(
                                child: Material(
                                    type: MaterialType.transparency,
                                    child: InkWell(
                                      onTap: () {

                                        origin = Marker(
                                            markerId: const MarkerId('og'),
                                            position: LatLng(
                                                position!.latitude,
                                                position!.longitude),
                                            infoWindow: InfoWindow(
                                                title:
                                                    '${filterResult[index]['name']}',
                                                snippet: 'asd'));

                                        destination = Marker(
                                            markerId: const MarkerId('des'),
                                            position: LatLng(
                                                filterResult[index]
                                                    ['coordinates'][0],
                                                filterResult[index]
                                                    ['coordinates'][1]),
                                            infoWindow: InfoWindow(
                                                title:
                                                    '${filterResult[index]['name']}',
                                                snippet: 'asd'));

                                        _info = null;

                                        showGetDirection = true;
                                        setState(() {
                                          showDistanceAndDuration = true;
                                        });

                                        goTodisLocation(
                                            filterResult[index]['coordinates']);
                                        fcontroller.close();
                                      },
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    itemCount: filterResult.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
