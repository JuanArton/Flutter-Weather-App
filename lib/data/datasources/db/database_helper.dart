import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:weatherapp/data/models/saved_location_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblSavedLocation = 'savedlocation';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/location.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblSavedLocation (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lat DOUBLE,
        lon DOUBLE
      );
    ''');
  }

  Future<int> insertLocation(SavedLocationTable location) async {
    final db = await database;
    return await db!.insert(_tblSavedLocation, location.toJson());
  }

  Future<int> removeLocation(SavedLocationTable location) async {
    final db = await database;
    return await db!.delete(
      _tblSavedLocation,
      where: 'id = ?',
      whereArgs: [location.id],
    );
  }

  Future<List<Map<String, dynamic>>> getLocationList() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblSavedLocation);

    return results;
  }
}
