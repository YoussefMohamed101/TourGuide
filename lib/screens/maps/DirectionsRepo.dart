import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/screens/maps/directions_model.dart';
import 'package:untitled2/auth/secrets.dart';

import 'distanceMatrix_model.dart';

class DirectionsRepo{
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';
  late final Dio _dio;

  DirectionsRepo({Dio? dio}): _dio = dio ?? Dio();

  Future<Direction> getDirections({
  required LatLng origin,
  required LatLng destination,
}) async{
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': (destination.latitude == 24.013471353412196 && destination.longitude == 32.87744471727956) ?  '24.019439447067597, 32.86627602383781' :'${destination.latitude},${destination.longitude}',
          'key': '$Api_Key'
        }
      );

      if(response.statusCode == 200){
        return Direction.fromMap(response.data);
      }
      return Future.error('sadasd');
  }

}

class DistanceMatrixRepo{
  static String _baseUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=';
  late final Dio _dio;

  DistanceMatrixRepo({Dio? dio}): _dio = dio ?? Dio();

  Future<DistanceMatrix> getDistance({
    required var origin,
    required var destination,
  }) async{
    _baseUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=';
    print('8888888888888888888888888888888888888888');
    print(origin);
    print(destination[0]['coordinates']);
    for (var i = 0; i < destination.length; i++) {
      if(destination[i]['id'] == '6w8oa6WWPhzPIDHOCGYW'){
        _baseUrl =
            _baseUrl + '24.019388058436412%2C32.86623382857462%7C';
        continue;
      }
      _baseUrl =
          _baseUrl + '${destination[i]['coordinates'][0]}%2C${destination[i]['coordinates'][1]}%7C';
    }

    _baseUrl = _baseUrl +
        '&origins=${origin[0]}%2C${origin[1]}&key=$Api_Key';
    print(_baseUrl);
    final response = await _dio.get(
        _baseUrl,
    );

    if(response.statusCode == 200){
      return DistanceMatrix.fromMap(response.data);
    }
    return Future.error('sadasd');
  }

}