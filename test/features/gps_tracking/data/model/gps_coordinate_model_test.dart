import 'package:flutter_test/flutter_test.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/data/models/gps_coordinate_model.dart';

void main() {
  final dateTime = DateTime(2023, 1, 15, 10, 30);
  final dateTimeString = '2023-01-15T10:30:00.000';

  GpsCoordinateModel gpsCoordinateModel = GpsCoordinateModel(
    id: 1,
    journeyId: 101,
    longitude: 10.123,
    latitude: 20.456,
    altitude: 50.0,
    timestamp: dateTime,
    accuracy: 3.5,
    altitudeAccuracy: 1.2,
    heading: 90.0,
    headingAccuracy: 5.0,
    speed: 15.0,
    speedAccuracy: 2.0,
  );
  GpsCoordinateModel gpsCoordinateModelWithNull = GpsCoordinateModel(
    id: 2,
    longitude: 30.789,
    latitude: 40.987,
    timestamp: dateTime,
  );

  group('GpsCoordinateModel', () {
    group('fromJson', () {
      test(
        'should return a valid model when all fields are present and valid',
        () {
          final Map<String, dynamic> jsonMap = {
            GPSCoordinateFields.id: 1,
            GPSCoordinateFields.journeyId: 101,
            GPSCoordinateFields.longitude: 10.123,
            GPSCoordinateFields.latitude: 20.456,
            GPSCoordinateFields.altitude: 50.0,
            GPSCoordinateFields.timestamp: dateTimeString,
            GPSCoordinateFields.accuracy: 3.5,
            GPSCoordinateFields.altitudeAccuracy: 1.2,
            GPSCoordinateFields.heading: 90.0,
            GPSCoordinateFields.headingAccuracy: 5.0,
            GPSCoordinateFields.speed: 15.0,
            GPSCoordinateFields.speedAccuracy: 2.0,
          };

          final result = GpsCoordinateModel.fromJson(jsonMap);

          expect(result, gpsCoordinateModel);
        },
      );

      test('should return a valid model when nullable fields are null', () {
        final Map<String, dynamic> jsonMap = {
          GPSCoordinateFields.id: 2,
          GPSCoordinateFields.longitude: 30.789,
          GPSCoordinateFields.latitude: 40.987,
          GPSCoordinateFields.timestamp: dateTimeString,
        };

        final result = GpsCoordinateModel.fromJson(jsonMap);

        expect(result, gpsCoordinateModelWithNull);
      });

      test(
        'should throw TypeError when a required field is missing or wrong type',
        () {
          final Map<String, dynamic> jsonMap = {
            GPSCoordinateFields.id: 1,
            GPSCoordinateFields.latitude: 20.456,
            GPSCoordinateFields.timestamp: dateTimeString,
          };
          expect(
            () => GpsCoordinateModel.fromJson(jsonMap),
            throwsA(isA<TypeError>()),
          );
        },
      );
    });

    group('toJson', () {
      test('should return a JSON map containing all appropriate data', () {
        final result = gpsCoordinateModel.toJson();

        final expectedJsonMap = {
          GPSCoordinateFields.id: 1,
          GPSCoordinateFields.journeyId: 101,
          GPSCoordinateFields.longitude: 10.123,
          GPSCoordinateFields.latitude: 20.456,
          GPSCoordinateFields.altitude: 50.0,
          GPSCoordinateFields.timestamp: dateTimeString,
          GPSCoordinateFields.accuracy: 3.5,
          GPSCoordinateFields.altitudeAccuracy: 1.2,
          GPSCoordinateFields.heading: 90.0,
          GPSCoordinateFields.headingAccuracy: 5.0,
          GPSCoordinateFields.speed: 15.0,
          GPSCoordinateFields.speedAccuracy: 2.0,
        };

        expect(result, expectedJsonMap);
      });

      test('should return a JSON map with null values for nullable fields', () {
        final result = gpsCoordinateModelWithNull.toJson();

        final expectedJsonMap = {
          GPSCoordinateFields.id: 2,
          GPSCoordinateFields.journeyId: null,
          GPSCoordinateFields.longitude: 30.789,
          GPSCoordinateFields.latitude: 40.987,
          GPSCoordinateFields.altitude: null,
          GPSCoordinateFields.timestamp: dateTimeString,
          GPSCoordinateFields.accuracy: null,
          GPSCoordinateFields.altitudeAccuracy: null,
          GPSCoordinateFields.heading: null,
          GPSCoordinateFields.headingAccuracy: null,
          GPSCoordinateFields.speed: null,
          GPSCoordinateFields.speedAccuracy: null,
        };

        expect(result, expectedJsonMap);
      });
    });

    group('toCreateJson', () {
      test('should return a JSON map for creation with ID as null', () {
        final result = gpsCoordinateModel.toCreateJson();

        final expectedJsonMap = {
          GPSCoordinateFields.id: null,
          GPSCoordinateFields.journeyId: 101,
          GPSCoordinateFields.longitude: 10.123,
          GPSCoordinateFields.latitude: 20.456,
          GPSCoordinateFields.altitude: 50.0,
          GPSCoordinateFields.timestamp: dateTimeString,
          GPSCoordinateFields.accuracy: 3.5,
          GPSCoordinateFields.altitudeAccuracy: 1.2,
          GPSCoordinateFields.heading: 90.0,
          GPSCoordinateFields.headingAccuracy: 5.0,
          GPSCoordinateFields.speed: 15.0,
          GPSCoordinateFields.speedAccuracy: 2.0,
        };

        expect(result, expectedJsonMap);
      });

      test('should handle nullable fields correctly in toCreateJson', () {
        final result = gpsCoordinateModelWithNull.toCreateJson();

        final expectedJsonMap = {
          GPSCoordinateFields.id: null,
          GPSCoordinateFields.journeyId: null,
          GPSCoordinateFields.longitude: 30.789,
          GPSCoordinateFields.latitude: 40.987,
          GPSCoordinateFields.altitude: null,
          GPSCoordinateFields.timestamp: dateTimeString,
          GPSCoordinateFields.accuracy: null,
          GPSCoordinateFields.altitudeAccuracy: null,
          GPSCoordinateFields.heading: null,
          GPSCoordinateFields.headingAccuracy: null,
          GPSCoordinateFields.speed: null,
          GPSCoordinateFields.speedAccuracy: null,
        };

        expect(result, expectedJsonMap);
      });
    });

    group('fromEntity', () {
      test('should convert a GpsCoordinateEntity to GpsCoordinateModel', () {
        final GpsCoordinateEntity entity = GpsCoordinateEntity(
          id: 3,
          journeyId: 103,
          longitude: 50.0,
          latitude: 60.0,
          timestamp: dateTime,
          altitude: 120.0,
          accuracy: 4.0,
          altitudeAccuracy: 1.5,
          heading: 180.0,
          headingAccuracy: 6.0,
          speed: 20.0,
          speedAccuracy: 2.5,
        );

        final result = GpsCoordinateModel.fromEntity(entity);

        expect(result.id, entity.id);
        expect(result.journeyId, entity.journeyId);
        expect(result.longitude, entity.longitude);
        expect(result.latitude, entity.latitude);
        expect(result.timestamp, entity.timestamp);
        expect(result.altitude, entity.altitude);
        expect(result.accuracy, entity.accuracy);
        expect(result.altitudeAccuracy, entity.altitudeAccuracy);
        expect(result.heading, entity.heading);
        expect(result.headingAccuracy, entity.headingAccuracy);
        expect(result.speed, entity.speed);
        expect(result.speedAccuracy, entity.speedAccuracy);
        expect(result, isA<GpsCoordinateModel>());
      });
    });

    group('toEntity', () {
      test('should return itself as a GpsCoordinateEntity', () {
        final result = gpsCoordinateModel.toEntity();

        expect(result, isA<GpsCoordinateEntity>());
        expect(result, equals(gpsCoordinateModel));
      });
    });
  });
}
