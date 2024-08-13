import '../../domain/entities/weather.dart';

class WeatherModel {
  WeatherModel({
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
    required this.date
  });

  final String weather;
  final String icon;
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int seaLevel;
  final int grndLevel;
  final int visibility;
  final double windSpeed;
  final double windGust;
  final int cloudiness;
  final int? sunset;
  final int? sunrise;
  final String? city;
  final String? date;

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
    weather: json["description"],
    icon: json["icon"],
    temp: json["temp"],
    feelsLike: json["feels_like"],
    tempMin: json["temp_min"],
    tempMax: json["temp_max"],
    pressure: json["pressure"],
    humidity: json["humidity"],
    seaLevel: json["sea_level"],
    grndLevel: json["grnd_level"],
    visibility: json["visibility"],
    windSpeed: json["speed"],
    windGust: json["gust"],
    cloudiness: json["all"],
    sunset: json["sunset"],
    sunrise: json["sunrise"],
    city: json["name"],
    date: json["dt_txt"]
  );

  Weather toEntity() {
    return Weather(
        weather: capitalizeFirstCharacter(weather),
        icon: icon,
        temp: temp,
        feelsLike: feelsLike,
        tempMin: tempMin,
        tempMax: tempMax,
        pressure: pressure,
        humidity: humidity,
        seaLevel: seaLevel,
        grndLevel: grndLevel,
        visibility: visibility,
        windSpeed: windSpeed,
        windGust: windGust,
        cloudiness: cloudiness,
        sunset: sunset,
        sunrise: sunrise,
        city: city,
        date: date
    );
  }

  String capitalizeFirstCharacter(String input) {
    if (input.isEmpty) {
      return input;
    }

    List<String> words = input.split(' ');
    List<String> capitalizedWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        String capitalizedWord =
            word[0].toUpperCase() + word.substring(1).toLowerCase();
        capitalizedWords.add(capitalizedWord);
      }
    }

    return capitalizedWords.join(' ');
  }
}
