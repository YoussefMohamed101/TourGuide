import 'package:geolocator/geolocator.dart';

class LocationService {

    static bool? serviceEnabled;
    static LocationPermission? permission;


    static Future<void> permissioncheck() async {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      permission = await Geolocator.checkPermission();
    }


  static Future<Position?> determinePosition() async {
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // return Future.error('Location permissions are denied');
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // return Future.error(
        //     'Location permissions are permanently denied, we cannot request permissions.');
        print('dasdas');
        return null;
      }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static Future getLastKnownPosition() async {
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getLastKnownPosition();
  }
}
