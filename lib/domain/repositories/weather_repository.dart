import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/domain/entities/weather.dart';

import '../../common/failure.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(double lat, double lon);
  Future<Either<Failure, List<Weather>>> getWeatherForecast(double lat, double lon);
  Future<Either<Failure, Position?>> getCurrentPosition();
}