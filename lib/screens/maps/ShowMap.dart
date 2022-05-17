import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:untitled2/services/location_services.dart';

class Show_Maps extends StatefulWidget {
  const Show_Maps({Key? key}) : super(key: key);
  @override
  State<Show_Maps> createState() => _Show_MapsState();
}

List<Map<String, Object>> markid = [
  {
    'MarkerId': 'main',
    'position': [25.717153892996087, 32.627239376306534],
    'infoWindow': {'title': 'Karnak Temple', 'snippet': ''}
  },
  {
    'MarkerId': '1',
    'position': [25.718901397546496, 32.65728279017053],
    'infoWindow': {'title': 'Karnak Temple', 'snippet': ''}
  },
  {
    'MarkerId': '2',
    'position': [25.69952344259581, 32.639049044897],
    'infoWindow': {'title': 'Luxor temple', 'snippet': ''}
  },
  {
    'MarkerId': '3',
    'position': [25.74021262120803, 32.601406455533045],
    'infoWindow': {'title': 'Valley of the Kings', 'snippet': ''}
  },
  {
    'MarkerId': '4',
    'position': [25.73833528636797, 32.606504011053644],
    'infoWindow': {'title': 'Hatshepsut Temple', 'snippet': ''}
  },
  {
    'MarkerId': '5',
    'position': [25.707748536371035, 32.644473998157565],
    'infoWindow': {'title': 'Luxor Museum', 'snippet': ''}
  },
  {
    'MarkerId': '6',
    'position': [25.737335699693887, 32.60773470000879],
    'infoWindow': {
      'title': 'Deir el-Bahari (the mortuary temple of Hatshepsut)',
      'snippet': ''
    }
  },
  {
    'MarkerId': '7',
    'position': [25.71936384616683, 32.60136155768057],
    'infoWindow': {'title': 'Habu . city', 'snippet': ''}
  },
  {
    'MarkerId': '8',
    'position': [25.720660327905865, 32.61043682454598],
    'infoWindow': {'title': 'thankful giant', 'snippet': ''}
  },
  {
    'MarkerId': '9',
    'position': [25.72808266090975, 32.60142500000878],
    'infoWindow': {'title': 'Deir el-Madina', 'snippet': ''}
  },
  {
    'MarkerId': '10',
    'position': [25.71169844959537, 32.655199088963926],
    'infoWindow': {'title': 'mut temple', 'snippet': ''}
  },
  {
    'MarkerId': '11',
    'position': [25.728053191383683, 32.610452153381864],
    'infoWindow': {'title': 'ramesium', 'snippet': ''}
  },
  {
    'MarkerId': '12',
    'position': [25.71694019759933, 32.658626060128036],
    'infoWindow': {'title': 'holy lake', 'snippet': ''}
  },
  {
    'MarkerId': '13',
    'position': [25.728639174801547, 32.59291385338187],
    'infoWindow': {'title': 'Valley of the Queens', 'snippet': ''}
  },
  {
    'MarkerId': '14',
    'position': [25.70235482074173, 32.63988878221777],
    'infoWindow': {'title': 'Mummification Museum', 'snippet': ''}
  },
  {
    'MarkerId': '15',
    'position': [25.732742718801365, 32.62811748466523],
    'infoWindow': {'title': 'Temple of Seti I', 'snippet': ''}
  },
  {
    'MarkerId': '16',
    'position': [25.683627781875092, 32.622824188963925],
    'infoWindow': {'title': 'Banana Island', 'snippet': ''}
  },
  {
    'MarkerId': '17',
    'position': [25.716614430042846, 32.65581130000878],
    'infoWindow': {'title': 'khansu sat', 'snippet': ''}
  },
  {
    'MarkerId': '18',
    'position': [25.71946717798471, 32.65616391779981],
    'infoWindow': {'title': 'rams street', 'snippet': ''}
  },
];


class _Show_MapsState extends State<Show_Maps> {
  static List tempposition = markid[0]['position'] as List;
  static double zoom = 12.2222;
  static Position? position;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _myCameraPosition = CameraPosition(
    target: position == null
        ? LatLng(25.71946717798471, 32.65616391779981)
        : LatLng(position!.latitude, position!.longitude),
    zoom: 16.4746,
  );
  static final CameraPosition _tempCameraPosition = CameraPosition(
    target: LatLng(tempposition[0], tempposition[1]),
    // target: position == null
    //     ? LatLng(25.71946717798471, 32.65616391779981)
    //     : LatLng(position!.latitude, position!.longitude),
    zoom: zoom,
  );

  Future<void> getMyLocation() async {
    await LocationService.determinePosition();
    position = await Geolocator.getLastKnownPosition().whenComplete(() {
      setState((){});
    });
  }

  var myMarkers = HashSet<Marker>();

  Future<void> _goToMyCurrLocation() async {
    //await getMyLocation();
    await getMyLocation();
    print('${position?.latitude},  ${position?.longitude}');
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myCameraPosition));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 1; i < markid.length; i++) {
      var markid1 = markid[i]['MarkerId'] as String;
      List position = markid[i]['position'] as List;
      Map infoWindow = markid[i]['infoWindow'] as Map;

      myMarkers.add(
        Marker(
            markerId: MarkerId(markid1),
            position: LatLng(position[0], position[1]),
            infoWindow: InfoWindow(
                title: infoWindow['title'],
                snippet: infoWindow['snippet'])),
      );
    }
    //print("${position!.longitude},and ${position!.latitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(),
      // drawerEdgeDragWidth: 10,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(249, 168, 38, 1),
        title: Text(
          'First Google Map',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          //position != null?
          GoogleMap(
                  onLongPress: (LatLng position) {
                    print("${position.latitude},   ${position.longitude}");
                  },
                  mapToolbarEnabled: false,
                  rotateGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: _tempCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: Set.from(myMarkers),
                ),
              // : Center(
              //     child: Container(
              //       child: CircularProgressIndicator(
              //         color: Color.fromRGBO(249, 168, 38, 1),
              //       ),
              //     ),
              //   ),
          //buildFloatingSearchBar(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(249, 168, 38, 1.0),
        onPressed: () => _goToMyCurrLocation(),
        child: Icon(Icons.gps_fixed),
      ),
    );

    return Scaffold(
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // buildMap(),
          //buildBottomNavigationBar(),
          buildFloatingSearchBar(),
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      automaticallyImplyDrawerHamburger: false,
      automaticallyImplyBackButton: false,
      hint: 'Search...',
      elevation: 6,
      hintStyle: TextStyle(fontSize: 18),
      queryStyle: TextStyle(fontSize: 18),
      //padding: EdgeInsets.all(8),
      margins: EdgeInsets.all(8),
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
          color: Color.fromRGBO(249, 168, 38, 1),
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 90, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

// Future<void> _getMyLocation() async {
//   LocationData _myLocation = await LocationService().getLocation();
//   _animateCamera(LatLng(_myLocation.latitude, _myLocation.longitude));
// }
//
// Future<void> _animateCamera(LatLng _location) async {
//   final GoogleMapController controller = await _controller.future;
//   CameraPosition _cameraPosition = CameraPosition(
//     target: _location,
//     zoom: 14.4746,
//   );
//   print(
//       "animating camera to (lat: ${_location.latitude}, long: ${_location.longitude}");
//   controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
// }
