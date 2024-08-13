import 'package:geolocator/geolocator.dart';

class LocationHandler {
  LocationHandler._privateConstructor();

  // Static instance
  static final LocationHandler _instance = LocationHandler._privateConstructor();

  // Factory constructor to return the same instance
  factory LocationHandler() {
    return _instance;
  }

  Position? position;

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
