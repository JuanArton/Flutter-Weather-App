import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/entities/weather.dart';
import 'package:weatherapp/domain/repositories/weather_repository.dart';

import '../../common/failure.dart';

class GetCurrentWeather {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  Future<Either<Failure, Weather>> execute(double lat, double lon) {
    return repository.getCurrentWeather(lat, lon);
  }
}