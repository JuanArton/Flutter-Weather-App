import 'package:flutter/cupertino.dart';
import 'package:weatherapp/domain/entities/weather.dart';
import '../../common/state_enum.dart';
import '../../domain/usecase/get_current_weather.dart';

class WeatherNotifier extends ChangeNotifier {
  final GetCurrentWeather getCurrentWeather;

  WeatherNotifier({
    required this.getCurrentWeather,
  });

  Weather? _currentWeather;
  Weather? get currentWeather => _currentWeather;

  RequestState _currentWeatherState = RequestState.Empty;
  RequestState get currentWeatherState => _currentWeatherState;

  String _message = '';
  String get message => _message;

  Future<void> fetchCurrentWeather(double lat, double lon) async {
    _currentWeatherState = RequestState.Loading;
    notifyListeners();

    final result = await getCurrentWeather.execute(lat, lon);
    result.fold(
        (failure) {
          _currentWeatherState = RequestState.Error;
          _message = failure.message;
          notifyListeners();
        },
        (weatherData) {
          _currentWeatherState = RequestState.Loaded;
          _currentWeather = weatherData;
          notifyListeners();
        }
    );
  }
}