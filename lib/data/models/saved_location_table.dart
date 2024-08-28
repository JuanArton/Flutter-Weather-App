import 'package:weatherapp/domain/entities/saved_location.dart';

class SavedLocationTable {
  final int? id;
  final double? lat;
  final double? lon;

  const SavedLocationTable({
    required this.id,
    required this.lat,
    required this.lon,
  });

  factory SavedLocationTable.fromEntity(weather location) => SavedLocationTable(
    id: location.id,
    lat: location.lat,
    lon: location.lon,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lat': lat,
    'lon': lon,
  };

  factory SavedLocationTable.fromMap(Map<String, dynamic> map) => SavedLocationTable(
    id: map['id'],
    lat: map['lat'],
    lon: map['lon'],
  );

  weather toEntity() => weather.location(
    id: id,
    lat: lat,
    lon: lon,
  );
}
