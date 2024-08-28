import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/common/exception.dart';
import 'package:weatherapp/data/models/forecast_response.dart';
import 'package:weatherapp/data/models/weather_response.dart';

import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(double lat, double lon);
  Future<List<WeatherModel>> getWeatherForecast(double lat, double lon);
  Future<Position?> getCurrentLocation();
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  static const API_KEY = "appid=63b81ac5416241f936ef4e64b757f86c";
  static const BASE_URL = "https://api.openweathermap.org/data/2.5";

  final http.Client client;

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getCurrentWeather(double lat, double lon) async {
    final response = await client.get(Uri.parse('$BASE_URL/weather?lat=$lat&lon=$lon&$API_KEY&units=metric'));
    if (response.statusCode == 200) {
      return WeatherResponse.fromJson(json.decode(response.body)).toWeatherModel();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<WeatherModel>> getWeatherForecast(double lat, double lon) async {
    final response = await client.get(Uri.parse('$BASE_URL/forecast?lat=$lat&lon=$lon&$API_KEY&units=metric'));

    if (response.statusCode == 200) {
      return ForecastResponse.fromJson(json.decode(response.body)).toWeatherList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Position?> getCurrentLocation() async {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
  }
}