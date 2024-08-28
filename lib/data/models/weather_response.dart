import 'package:weatherapp/data/models/weather_model.dart';

class WeatherResponse {
  final Map<String, dynamic>? coord;
  final List<Map<String, dynamic>>? weather;
  final Map<String, dynamic>? main;
  final int? visibility;
  final Map<String, dynamic>? wind;
  final Map<String, dynamic>? clouds;
  final Map<String, dynamic>? sys;
  final String? name;
  final String? date;
  final int? timezone;

  WeatherResponse({
    required this.coord,
    required this.weather,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.sys,
    required this.name,
    required this.date,
    required this.timezone
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      coord: json['coord'],
      weather: List<Map<String, dynamic>>.from(json['weather']),
      main: json['main'],
      visibility: json['visibility'],
      wind: json['wind'],
      clouds: json['clouds'],
      sys: json['sys'],
      name: json['name'],
      date: json['dt_txt'],
      timezone: json['timezone']
    );
  }

  WeatherModel toWeatherModel() {
    return WeatherModel(
      lat: coord?['lat']?.toDouble() ?? 0.0,
      lon: coord?['lon']?.toDouble() ?? 0.0,
      weather: weather?[0]['description'] ?? 'Unknown',
      icon: weather?[0]['icon'] ?? '01d',
      temp: main?['temp']?.toDouble() ?? 0.0,
      feelsLike: main?['feels_like']?.toDouble() ?? 0.0,
      tempMin: main?['temp_min']?.toDouble() ?? 0.0,
      tempMax: main?['temp_max']?.toDouble() ?? 0.0,
      pressure: main?['pressure'] ?? 0,
      humidity: main?['humidity'] ?? 0,
      seaLevel: main?['sea_level'] ?? 0,
      grndLevel: main?['grnd_level'] ?? 0,
      visibility: visibility ?? 0,
      windSpeed: wind?['speed']?.toDouble() ?? 0,
      windGust: wind?['gust']?.toDouble() ?? 0,
      cloudiness: clouds?['all'] ?? 0,
      sunset: sys?['sunset'] ?? 0,
      sunrise: sys?['sunrise'] ?? 0,
      city: name ?? 'Unknown City',
      date: date ?? '0000-01-01',
      timezone: timezone ?? 0,
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
