import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:latlong2/latlong.dart';

void main() {
  final gpsEntity = GpsCoordinateEntity(
    id: 1,
    journeyId: 101,
    longitude: 10.123,
    latitude: 20.456,
    timestamp: DateTime(2023, 1, 15, 10, 30),
    accuracy: 3.5,
    altitude: 50.0,
    altitudeAccuracy: 1.2,
    heading: 90.0,
    headingAccuracy: 5.0,
    speed: 15.0,
    speedAccuracy: 2.0,
  );

  group('GpsCoordinateEntity', () {
    test('should be a subclass of Equatable', () {
      expect(gpsEntity, isA<Equatable>());
    });

    test('should return correct props for equality comparison', () {
      final gpsEntity2 = GpsCoordinateEntity(
        id: 1,
        journeyId: 101,
        longitude: 10.123,
        latitude: 20.456,
        timestamp: DateTime(2023, 1, 15, 10, 30),
        accuracy: 3.5,
        altitude: 50.0,
        altitudeAccuracy: 1.2,
        heading: 90.0,
        headingAccuracy: 5.0,
        speed: 15.0,
        speedAccuracy: 2.0,
      );

      final gpsEntityDifferentId = GpsCoordinateEntity(
        id: 2,
        journeyId: 101,
        longitude: 10.123,
        latitude: 20.456,
        timestamp: DateTime(2023, 1, 15, 10, 30),
        accuracy: 3.5,
        altitude: 50.0,
        altitudeAccuracy: 1.2,
        heading: 90.0,
        headingAccuracy: 5.0,
        speed: 15.0,
        speedAccuracy: 2.0,
      );

      final gpsEntityDifferentAccuracy = GpsCoordinateEntity(
        id: 1,
        journeyId: 101,
        longitude: 10.123,
        latitude: 20.456,
        timestamp: DateTime(2023, 1, 15, 10, 30),
        accuracy: 4.0,
        altitude: 50.0,
        altitudeAccuracy: 1.2,
        heading: 90.0,
        headingAccuracy: 5.0,
        speed: 15.0,
        speedAccuracy: 2.0,
      );

      // Test equality
      expect(gpsEntity, gpsEntity2);
      expect(gpsEntity.hashCode, gpsEntity2.hashCode);

      // Test inequality id
      expect(gpsEntity, isNot(gpsEntityDifferentId));
      expect(gpsEntity.hashCode, isNot(gpsEntityDifferentId.hashCode));

      // Test inequality accuracy
      expect(gpsEntity, isNot(gpsEntityDifferentAccuracy));
      expect(gpsEntity.hashCode, isNot(gpsEntityDifferentAccuracy.hashCode));
    });

    test(
      'copyWith should return a new object with the same values if no arguments are provided',
      () {
        final result = gpsEntity.copyWith();
        expect(result, gpsEntity);
        expect(identical(result, gpsEntity), isFalse);
      },
    );

    test('copyWith should return a new object with updated ID', () {
      final updatedId = 99;
      final result = gpsEntity.copyWith(id: updatedId);

      expect(result.id, updatedId);
      expect(result.longitude, gpsEntity.longitude);
      expect(result.timestamp, gpsEntity.timestamp);
      expect(result, isNot(gpsEntity));
    });

    test(
      'copyWith should return a new object with updated nullable fields',
      () {
        final updatedAccuracy = 7.0;
        final updatedJourneyId = 200;
        final result = gpsEntity.copyWith(
          accuracy: updatedAccuracy,
          journeyId: updatedJourneyId,
        );

        expect(result.accuracy, updatedAccuracy);
        expect(result.journeyId, updatedJourneyId);
        expect(result.longitude, gpsEntity.longitude);
        expect(result, isNot(gpsEntity));
      },
    );

    test('latlng getter should return correct LatLng object', () {
      final latLng = gpsEntity.latlng;

      expect(latLng, isA<LatLng>());
      expect(latLng.latitude, gpsEntity.latitude);
      expect(latLng.longitude, gpsEntity.longitude);
    });
  });
}
