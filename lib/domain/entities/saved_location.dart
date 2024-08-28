class weather {
  weather({
    required this.id,
    required this.lat,
    required this.lon,
  });

  weather.location({
    required this.id,
    required this.lat,
    required this.lon,
  });

  final int? id;
  final double? lat;
  final double? lon;
}