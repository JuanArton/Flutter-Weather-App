import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/entities/weather.dart';
import 'package:weatherapp/domain/repositories/weather_repository.dart';

import '../../common/failure.dart';

class GetWeatherForecast {
  final WeatherRepository repository;

  GetWeatherForecast(this.repository);

  Future<Either<Failure, List<Weather>>> execute(double lat, double lon) {
    return repository.getWeatherForecast(lat, lon);
  }
}