import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class GlobalSingleton {
  GlobalSingleton._privateConstructor();

  // Static instance
  static final GlobalSingleton _instance = GlobalSingleton._privateConstructor();

  // Factory constructor to return the same instance
  factory GlobalSingleton() {
    return _instance;
  }

  Position? position;
  Position? newPosition;
  final glbKey = GlobalKey();

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

}
