import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/common/failure.dart';

import '../repositories/weather_repository.dart';

class GetCurrentLocation {
  final WeatherRepository repository;

  GetCurrentLocation(this.repository);

  Future<Either<Failure, Position?>> execute() {
    return repository.getCurrentPosition();
  }
}