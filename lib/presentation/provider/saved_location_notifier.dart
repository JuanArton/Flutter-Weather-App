
import 'package:flutter/cupertino.dart';
import 'package:weatherapp/domain/entities/saved_location.dart';
import 'package:weatherapp/domain/entities/weather.dart';
import 'package:weatherapp/domain/usecase/get_saved_location.dart';
import 'package:weatherapp/domain/usecase/insert_location.dart';

import '../../common/state_enum.dart';

class SavedLocationNotifier extends ChangeNotifier {
  final GetSavedLocation getSavedLocation;
  final InsertLocation insertLocation;

  SavedLocationNotifier({
    required this.getSavedLocation,
    required this.insertLocation,
  });

  List<Weather>? _listWeather;
  List<Weather>? get listWeather => _listWeather;

  RequestState _listWeatherState = RequestState.Empty;
  RequestState get listWeatherState => _listWeatherState;

  String _message = '';
  String get message => _message;

  Future<void> fetchSavedLocation() async {
    _listWeatherState = RequestState.Loading;
    notifyListeners();

    final result = await getSavedLocation.execute();
    result.fold(
            (failure) {
              _listWeatherState = RequestState.Error;
              _message = failure.message;
              notifyListeners();
        },
            (data) {
              _listWeatherState = RequestState.Loaded;
              _listWeather = data;
              notifyListeners();
        }
    );
  }

  Future<void> addLocation(double lat, double lon) async {
    final result = await insertLocation.execute(
      weather(
          id: null,
          lat: lat,
          lon: lon
      )
    );

    await result.fold(
        (failure) async {
          _message = failure.message;
        },
        (success) async {
          _message = success;
        },
    );
  }
}