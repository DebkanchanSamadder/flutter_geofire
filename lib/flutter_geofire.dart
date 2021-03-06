import 'dart:async';

import 'package:flutter/services.dart';

class Geofire {
  static const MethodChannel _channel = const MethodChannel('geofire');

  static const EventChannel _stream = const EventChannel('geofireStream');

  static const onKeyEntered = "onKeyEntered";
  static const onGeoQueryReady = "onGeoQueryReady";
  static const onKeyMoved = "onKeyMoved";
  static const onKeyExited = "onKeyExited";

  static Stream<Map<String, dynamic>>? _queryAtLocation;

  static Future<bool> initialize(String path) async => await _channel
      .invokeMethod('GeoFire.start', <String, dynamic>{"path": path});

  static Future<bool> setLocation(
          String id, double latitude, double longitude) async =>
      (await _channel.invokeMethod<bool>('setLocation',
          <String, dynamic>{"id": id, "lat": latitude, "lng": longitude}))!;

  static Future<bool> removeLocation(String id) async => (await _channel
      .invokeMethod<bool>('removeLocation', <String, dynamic>{"id": id}))!;

  static Future<bool> stopListener() async =>
      (await _channel.invokeMethod<bool>('stopListener', <String, dynamic>{}))!;

  static FutureOr<Map<String, dynamic>> getLocation(String id) async =>
      (await _channel.invokeMethod<Map<String, dynamic>>(
              'getLocation', <String, dynamic>{"id": id})
          as FutureOr<Map<String, dynamic>>);

  static Stream<Map<String, dynamic>>? queryAtLocation(
      double lat, double lng, double radius) {
    _channel.invokeMethod('queryAtLocation',
        {"lat": lat, "lng": lng, "radius": radius}).then((result) {
      print("result" + result);
      if (_queryAtLocation == null) {
        _queryAtLocation =
            _stream.receiveBroadcastStream() as Stream<Map<String, dynamic>>;
      }
    }).catchError((error) {
      print("Error " + error);
    });

    return _queryAtLocation;
  }
}
