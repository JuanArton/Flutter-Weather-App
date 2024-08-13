import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:weatherapp/common/exception.dart';
import 'package:weatherapp/common/failure.dart';
import 'package:weatherapp/data/datasources/weather_remote_data_source.dart';
import 'package:weatherapp/domain/entities/weather.dart';
import 'package:weatherapp/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  
  WeatherRepositoryImpl({
    required this.remoteDataSource  
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
}