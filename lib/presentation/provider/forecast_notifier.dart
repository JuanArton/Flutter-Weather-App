import 'package:flutter/cupertino.dart';

import '../../common/state_enum.dart';
import '../../domain/entities/weather.dart';
import '../../domain/usecase/get_weather_forecast.dart';

class ForecastNotifier extends ChangeNotifier {
  final GetWeatherForecast getWeatherForecast;

  ForecastNotifier({
    required this.getWeatherForecast,
  });

  List<Weather>? _weatherForecast;
  List<Weather>? get weatherForecast => _weatherForecast;

  RequestState _weatherForecastState = RequestState.Empty;
  RequestState get weatherForecastState => _weatherForecastState;

  String _message = '';
  String get message => _message;

  Future<void> fetchWeatherForecast(double lat, double lon) async {
    _weatherForecastState = RequestState.Loading;
    notifyListeners();

    final result = await getWeatherForecast.execute(lat, lon);
    result.fold(
            (failure) {
          _weatherForecastState = RequestState.Error;
          _message = failure.message;
          notifyListeners();
        },
            (forecastData) {
          _weatherForecastState = RequestState.Loaded;
          _weatherForecast = forecastData;
          notifyListeners();
        }
    );
  }
}