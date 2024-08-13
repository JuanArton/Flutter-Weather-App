import 'package:get_it/get_it.dart';
import 'package:weatherapp/data/datasources/weather_remote_data_source.dart';
import 'package:weatherapp/data/repositories/weather_repository_impl.dart';
import 'package:weatherapp/domain/repositories/weather_repository.dart';
import 'package:weatherapp/domain/usecase/get_current_location.dart';
import 'package:weatherapp/domain/usecase/get_current_weather.dart';
import 'package:weatherapp/domain/usecase/get_weather_forecast.dart';
import 'package:weatherapp/presentation/provider/forecast_notifier.dart';
import 'package:weatherapp/presentation/provider/location_notifier.dart';
import 'package:weatherapp/presentation/provider/weather_notifier.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

void init() {
  locator.registerFactory(
        () => WeatherNotifier(getCurrentWeather: locator())
  );
  locator.registerFactory(
          () => ForecastNotifier(getWeatherForecast: locator())
  );
  locator.registerFactory(
      () => LocationNotifier(getCurrentLocation: locator())
  );

  locator.registerLazySingleton(() => GetCurrentWeather(locator()));
  locator.registerLazySingleton(() => GetWeatherForecast(locator()));
  locator.registerLazySingleton(() => GetCurrentLocation(locator()));

  locator.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(
        remoteDataSource: locator(),
      ),
  );

  locator.registerLazySingleton<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(client: locator())
  );

  locator.registerLazySingleton(() => http.Client());
}