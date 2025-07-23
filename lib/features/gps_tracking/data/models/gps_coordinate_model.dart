import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';

class GPSCoordinateFields {
  static const String tableName = 'gps_coordinates';
  static const String id = '_id';
  static const String longitude = 'longitude';
  static const String latitude = 'latitude';
  static const String timestamp = 'timestamp';
  static const String accuracy = 'accuracy';
  static const String journeyId = 'journeyId';
  static const String altitude = 'altitude';
  static const String altitudeAccuracy = 'altitudeAccuracy';
  static const String heading = 'heading';
  static const String headingAccuracy = 'headingAccuracy';
  static const String speed = 'speed';
  static const String speedAccuracy = 'speedAccuracy';

  static final List<String> values = [
    id,
    journeyId,
    longitude,
    latitude,
    altitude,
    timestamp,
    accuracy,
    altitudeAccuracy,
    heading,
    headingAccuracy,
    speed,
    speedAccuracy,
  ];

  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String intType = 'INTEGER NOT NULL';
  static const String textType = 'TEXT NOT NULL';
  static const String doubleType = 'DOUBLE NOT NULL';
  static const String doubleNullableType = 'DOUBLE';
  static const String intNullableType = 'INTEGER';
}

class GpsCoordinateModel extends GpsCoordinateEntity {
  const GpsCoordinateModel({
    required super.id,
    required super.longitude,
    required super.latitude,
    required super.timestamp,
    super.accuracy,
    super.journeyId,
    super.altitude,
    super.altitudeAccuracy,
    super.heading,
    super.headingAccuracy,
    super.speed,
    super.speedAccuracy,
  });

  factory GpsCoordinateModel.fromJson(Map<String, dynamic> json) {
    return GpsCoordinateModel(
      id: json[GPSCoordinateFields.id] as int,
      journeyId: json[GPSCoordinateFields.journeyId] as int?,
      longitude: json[GPSCoordinateFields.longitude] as double,
      latitude: json[GPSCoordinateFields.latitude] as double,
      altitude: json[GPSCoordinateFields.altitude] as double?,
      timestamp: DateTime.parse(json[GPSCoordinateFields.timestamp] as String),
      accuracy: json[GPSCoordinateFields.accuracy] as double?,
      altitudeAccuracy: json[GPSCoordinateFields.altitudeAccuracy] as double?,
      heading: json[GPSCoordinateFields.heading] as double?,
      headingAccuracy: json[GPSCoordinateFields.headingAccuracy] as double?,
      speed: json[GPSCoordinateFields.speed] as double?,
      speedAccuracy: json[GPSCoordinateFields.speedAccuracy] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      GPSCoordinateFields.id: id,
      GPSCoordinateFields.journeyId: journeyId,
      GPSCoordinateFields.longitude: longitude,
      GPSCoordinateFields.latitude: latitude,
      GPSCoordinateFields.altitude: altitude,
      GPSCoordinateFields.timestamp: timestamp.toIso8601String(),
      GPSCoordinateFields.accuracy: accuracy,
      GPSCoordinateFields.altitudeAccuracy: altitudeAccuracy,
      GPSCoordinateFields.heading: heading,
      GPSCoordinateFields.headingAccuracy: headingAccuracy,
      GPSCoordinateFields.speed: speed,
      GPSCoordinateFields.speedAccuracy: speedAccuracy,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      GPSCoordinateFields.id: null,
      GPSCoordinateFields.journeyId: journeyId,
      GPSCoordinateFields.longitude: longitude,
      GPSCoordinateFields.latitude: latitude,
      GPSCoordinateFields.altitude: altitude,
      GPSCoordinateFields.timestamp: timestamp.toIso8601String(),
      GPSCoordinateFields.accuracy: accuracy,
      GPSCoordinateFields.altitudeAccuracy: altitudeAccuracy,
      GPSCoordinateFields.heading: heading,
      GPSCoordinateFields.headingAccuracy: headingAccuracy,
      GPSCoordinateFields.speed: speed,
      GPSCoordinateFields.speedAccuracy: speedAccuracy,
    };
  }

  factory GpsCoordinateModel.fromEntity(GpsCoordinateEntity entity) {
    return GpsCoordinateModel(
      id: entity.id,
      journeyId: entity.journeyId,
      longitude: entity.longitude,
      latitude: entity.latitude,
      altitude: entity.altitude,
      timestamp: entity.timestamp,
      accuracy: entity.accuracy,
      altitudeAccuracy: entity.altitudeAccuracy,
      heading: entity.heading,
      headingAccuracy: entity.headingAccuracy,
      speed: entity.speed,
      speedAccuracy: entity.speedAccuracy,
    );
  }

  GpsCoordinateEntity toEntity() => this;
}
