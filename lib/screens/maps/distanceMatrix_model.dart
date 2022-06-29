
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DistanceMatrix{
  final List<dynamic> distance;
  final List<dynamic> duration;

  const DistanceMatrix({
    required this.distance,
    required this.duration,
  });

  factory DistanceMatrix.fromMap(Map<String,dynamic> map){
    // if((map['routes'] as List).isEmpty) return null;

    final data = Map<String,dynamic>.from(map['rows'][0]);
    var distance = [];
    var duration = [];
    print(data['elements'][0]['distance']);
    print(duration);
    for (var i = 0; i < data['elements'].length; i++) {
      print(i);
      distance.add({
        'distanceValue': data['elements'][i]['distance']['value'],
        'distanceText': data['elements'][i]['distance']['text'],
      });

      duration.add({
        'durationValue': data['elements'][i]['duration']['value'],
        'durationText': data['elements'][i]['duration']['text'],
      });
    }
    return DistanceMatrix(
      distance: distance,
      duration: duration,
    );

  }

}