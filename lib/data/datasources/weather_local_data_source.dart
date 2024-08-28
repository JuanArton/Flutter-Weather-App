import 'package:weatherapp/common/exception.dart';
import 'package:weatherapp/data/models/saved_location_table.dart';

import 'db/database_helper.dart';

abstract class WeatherLocalDataSource{
  Future<String> insertLocation(SavedLocationTable location);
  Future<String> removeLocation(SavedLocationTable location);
  Future<List<SavedLocationTable>> getLocationList();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final DatabaseHelper databaseHelper;

  WeatherLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<SavedLocationTable>> getLocationList() async {
    final result = await databaseHelper.getLocationList();
    return result.map((it) => SavedLocationTable.fromMap(it)).toList();
  }

  @override
  Future<String> insertLocation(SavedLocationTable location) async {
    try {
      await databaseHelper.insertLocation(location);
      return 'Location saved';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeLocation(SavedLocationTable location) async {
    try {
      await databaseHelper.removeLocation(location);
      return 'Location removed';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}