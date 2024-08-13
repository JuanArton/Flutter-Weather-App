
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/domain/usecase/get_current_location.dart';

import '../../common/state_enum.dart';
import '../../domain/usecase/get_weather_forecast.dart';

class LocationNotifier extends ChangeNotifier {
  final GetCurrentLocation getCurrentLocation;

  LocationNotifier({
    required this.getCurrentLocation,
  });

  Position? _position;
  Position? get position => _position;

  RequestState _positionState = RequestState.Empty;
  RequestState get positionState => _positionState;

  String _message = '';
  String get message => _message;

  Future<void> fetchCurrentLocation() async {
    _positionState = RequestState.Loading;
    notifyListeners();

    final result = await getCurrentLocation.execute();
    result.fold(
        (failure) {
          _positionState = RequestState.Error;
          _message = failure.message;
          notifyListeners();
        },
        (location) {
          _positionState = RequestState.Loaded;
          _position = location;
          notifyListeners();
        }
    );
  }
}