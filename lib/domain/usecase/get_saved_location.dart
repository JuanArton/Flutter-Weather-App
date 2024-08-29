import 'package:dartz/dartz.dart';
import 'package:weatherapp/domain/entities/weather.dart';

import '../../common/failure.dart';
import '../repositories/weather_repository.dart';

class GetSavedLocation {
  final WeatherRepository repository;

  GetSavedLocation(this.repository);

  Future<Either<Failure, List<Weather>>> execute() {
    return repository.getLocationList();
  }
}
