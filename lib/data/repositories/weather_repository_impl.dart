import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:weatherapp/common/exception.dart';
import 'package:weatherapp/common/failure.dart';
import 'package:weatherapp/data/datasources/weather_local_data_source.dart';
import 'package:weatherapp/data/datasources/weather_remote_data_source.dart';
import 'package:weatherapp/data/models/saved_location_table.dart';
import 'package:weatherapp/domain/entities/saved_location.dart';
import 'package:weatherapp/domain/entities/weather.dart';
import 'package:weatherapp/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  
  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource
  });
  
  @override
  Future<Either<Failure, Weather>> getCurrentWeather(double lat, double lon) async {
    try {
      final result = await remoteDataSource.getCurrentWeather(lat, lon);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    }
  }

  @override
  Future<Either<Failure, List<Weather>>> getWeatherForecast(double lat, double lon) async {
    try {
      final result = await remoteDataSource.getWeatherForecast(lat, lon);
      return Right(
          result.map((x) => x.toEntity()).toList()
      );
    } on ServerException {
      return Left(ServerFailure(''));
    }
  }

  @override
  Future<Either<Failure, Position?>> getCurrentPosition() async {
    try {
      final result = await remoteDataSource.getCurrentLocation();
      return Right(
        result
      );
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  @override
  Future<Either<Failure, List<Weather>>> getLocationList() async {
    final list = await localDataSource.getLocationList();
    final result = list.map((it) => it.toEntity()).toList();

    List<Weather> weatherList = [];

    for (var i in result) {
      try {
        final result = await remoteDataSource.getCurrentWeather(i.lat!, i.lon!);
        weatherList.add(result.toEntity());
      } on ServerException {
        weatherList.add(
          Weather(
              lat: null, lon: null, weather: "Unknown", icon: "NA", temp: null,
              feelsLike: null, tempMin: null, tempMax: null, pressure: null,
              humidity: null, seaLevel: null, grndLevel: null, visibility: null,
              windSpeed: null, windGust: null, cloudiness: null,
              sunset: null, sunrise: null, city: "Unknown", date: null, timezone: 0
          )
        );
      }
    }
    return Right(weatherList);
  }

  @override
  Future<Either<Failure, String>> insertLocation(weather location) async {
    try {
      final result = await localDataSource.insertLocation(SavedLocationTable.fromEntity(location));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> removeLocation(weather location) async {
    try {
      final result = await localDataSource.removeLocation(SavedLocationTable.fromEntity(location));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}