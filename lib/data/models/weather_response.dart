import 'package:weatherapp/data/models/weather_model.dart';

class WeatherResponse {
  final List<Map<String, dynamic>> weather;
  final Map<String, dynamic> main;
  final int visibility;
  final Map<String, dynamic> wind;
  final Map<String, dynamic> clouds;
  final Map<String, dynamic>? sys;
  final String? name;
  final String? date;

  WeatherResponse({
    required this.weather,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.sys,
    required this.name,
    required this.date,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      weather: List<Map<String, dynamic>>.from(json['weather']),
      main: json['main'],
      visibility: json['visibility'],
      wind: json['wind'],
      clouds: json['clouds'],
      sys: json['sys'],
      name: json['name'],
      date: json['dt_txt'],
    );
  }

  WeatherModel toWeatherModel() {
    return WeatherModel(
      weather: weather[0]['description'],
      icon: weather[0]['icon'],
      temp: main['temp'].toDouble(),
      feelsLike: main['feels_like'].toDouble(),
      tempMin: main['temp_min'].toDouble(),
      tempMax: main['temp_max'].toDouble(),
      pressure: main['pressure'],
      humidity: main['humidity'],
      seaLevel: main['sea_level'],
      grndLevel: main['grnd_level'],
      visibility: visibility,
      windSpeed: wind['speed'].toDouble(),
      windGust: wind['gust'].toDouble(),
      cloudiness: clouds['all'],
      sunset: sys?['sunset'],
      sunrise: sys?['sunrise'],
      city: name,
      date: date
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weather': weather,
      'main': main,
      'visibility': visibility,
      'wind': wind,
      'clouds': clouds,
      'sys': sys,
      'name': name,
      'dt_txt' : date,
    };
  }
}
