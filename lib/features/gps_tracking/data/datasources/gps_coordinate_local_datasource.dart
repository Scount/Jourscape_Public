import 'package:flutter/material.dart';
import 'package:jourscape/features/gps_tracking/data/models/gps_coordinate_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class GPSCoordinateLocalDataSource {
  Future<void> initDatabase();
  Future<void> closeDatabase();
  Future<GpsCoordinateModel> createGPSCoordinate(GpsCoordinateModel coordinate);
  Future<List<GpsCoordinateModel>> getCoordinatesByDate(DateTime dateTime);
  Future<List<GpsCoordinateModel>> getCoordinatesByDateRange(
    DateTimeRange dateRange,
  );
  Future<int> updateCoordinate(GpsCoordinateModel coordinate);
  Future<int> deleteCoordinate(int id);
  Future<DateTime?> getLowestStoredDateTime();
}

class GpsCoordinateLocalDataSourceImpl implements GPSCoordinateLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'gps_coordinate.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
      CREATE TABLE ${GPSCoordinateFields.tableName} (
        ${GPSCoordinateFields.id} ${GPSCoordinateFields.idType},
        ${GPSCoordinateFields.journeyId} ${GPSCoordinateFields.intNullableType},
        ${GPSCoordinateFields.longitude} ${GPSCoordinateFields.doubleType},
        ${GPSCoordinateFields.latitude} ${GPSCoordinateFields.doubleType},
        ${GPSCoordinateFields.altitude} ${GPSCoordinateFields.doubleNullableType},
        ${GPSCoordinateFields.timestamp} ${GPSCoordinateFields.textType},
        ${GPSCoordinateFields.accuracy} ${GPSCoordinateFields.doubleNullableType},
        ${GPSCoordinateFields.altitudeAccuracy} ${GPSCoordinateFields.doubleNullableType},
        ${GPSCoordinateFields.heading} ${GPSCoordinateFields.doubleNullableType},
        ${GPSCoordinateFields.headingAccuracy} ${GPSCoordinateFields.doubleNullableType},
        ${GPSCoordinateFields.speed} ${GPSCoordinateFields.doubleNullableType},
        ${GPSCoordinateFields.speedAccuracy} ${GPSCoordinateFields.doubleNullableType}
      )
    ''');
  }

  @override
  Future<void> initDatabase() async {
    await database;
  }

  @override
  Future<GpsCoordinateModel> createGPSCoordinate(
    GpsCoordinateModel coordinate,
  ) async {
    final db = await database;
    final id = await db.insert(
      GPSCoordinateFields.tableName,
      coordinate.toCreateJson(),
    );
    return GpsCoordinateModel.fromEntity(
      coordinate.toEntity().copyWith(id: id),
    );
  }

  @override
  Future<List<GpsCoordinateModel>> getCoordinatesByDate(
    DateTime dateTime,
  ) async {
    final db = await database;
    final maps = await db.query(
      GPSCoordinateFields.tableName,
      columns: GPSCoordinateFields.values,
      where: '${GPSCoordinateFields.timestamp} BETWEEN ? AND ?',

      whereArgs: [
        dateTime.toIso8601String(),
        dateTime.copyWith(hour: 23, minute: 59, second: 59).toIso8601String(),
      ],
      orderBy: '${GPSCoordinateFields.timestamp} ASC',
    );

    if (maps.isNotEmpty) {
      return maps.map((e) => GpsCoordinateModel.fromJson(e)).toList();
    } else {
      throw Exception(
        'No coordinates found for ${dateTime.toIso8601String().substring(0, 10)}',
      );
    }
  }

  @override
  Future<List<GpsCoordinateModel>> getCoordinatesByDateRange(
    DateTimeRange dateRange,
  ) async {
    final db = await database;
    final maps = await db.query(
      GPSCoordinateFields.tableName,
      columns: GPSCoordinateFields.values,
      where: '${GPSCoordinateFields.timestamp} BETWEEN ? AND ?',
      whereArgs: [
        dateRange.start.toIso8601String(),
        dateRange.end.toIso8601String(),
      ],
    );

    if (maps.isNotEmpty) {
      return maps.map((e) => GpsCoordinateModel.fromJson(e)).toList();
    } else {
      throw Exception(
        'No coordinates found for ${dateRange.start} - ${dateRange.end}',
      );
    }
  }

  @override
  Future<int> updateCoordinate(GpsCoordinateModel coordinate) async {
    final db = await database;
    return db.update(
      GPSCoordinateFields.tableName,
      coordinate.toJson(),
      where: '${GPSCoordinateFields.id} = ?',
      whereArgs: [coordinate.id],
    );
  }

  @override
  Future<DateTime?> getLowestStoredDateTime() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT MIN(${GPSCoordinateFields.timestamp}) FROM ${GPSCoordinateFields.tableName}',
    );

    if (result.isNotEmpty && result.first.values.isNotEmpty) {
      final minTimestamp = result.first.values.first as String?;
      if (minTimestamp != null) {
        return DateTime.parse(minTimestamp);
      }
    }
    return null;
  }

  @override
  Future<int> deleteCoordinate(int id) async {
    final db = await database;
    return db.delete(
      GPSCoordinateFields.tableName,
      where: '${GPSCoordinateFields.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
