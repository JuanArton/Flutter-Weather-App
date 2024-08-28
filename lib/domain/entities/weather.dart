class Weather {
  Weather({
    required this.lat,
    required this.lon,
    required this.weather,
    required this.icon,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
    required this.visibility,
    required this.windSpeed,
    required this.windGust,
    required this.cloudiness,
    required this.sunset,
    required this.sunrise,
    required this.city,
    required this.date,
    required this.timezone,
  });

  final double? lat;
  final double? lon;
  final String? weather;
  final String? icon;
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? grndLevel;
  final int? visibility;
  final double? windSpeed;
  final double? windGust;
  final int? cloudiness;
  final int? sunset;
  final int? sunrise;
  final String? city;
  final String? date;
  final int? timezone;
}