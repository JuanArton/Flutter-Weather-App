import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/entities/saved_location.dart';
import 'package:weatherapp/domain/repositories/weather_repository.dart';

import '../../common/failure.dart';

class InsertLocation {
  final WeatherRepository repository;

  InsertLocation(this.repository);

  Future<Either<Failure, String>> execute(weather location) {
    return repository.insertLocation(location);
  }
}
