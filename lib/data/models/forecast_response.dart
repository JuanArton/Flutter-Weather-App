import 'package:weatherapp/data/models/weather_model.dart';
import 'package:weatherapp/data/models/weather_response.dart';

class ForecastResponse {
  final List<Map<String, dynamic>> list;

  ForecastResponse({
    required this.list,
  });

  factory ForecastResponse.fromJson(Map<String, dynamic> json) {
    return ForecastResponse(
      list: List<Map<String, dynamic>>.from(json['list']),
    );
  }

  List<WeatherModel> toWeatherList() {
    final weatherList = list.map((x) => WeatherResponse.fromJson(x).toWeatherModel());
    return weatherList.toList();
  }
}
