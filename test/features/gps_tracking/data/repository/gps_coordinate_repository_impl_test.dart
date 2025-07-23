import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jourscape/features/gps_tracking/data/repositories/gps_coordinate_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/features/gps_tracking/data/datasources/gps_coordinate_local_datasource.dart';
import 'package:jourscape/features/gps_tracking/data/models/gps_coordinate_model.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'gps_coordinate_repository_impl_test.mocks.dart';

@GenerateMocks([GPSCoordinateLocalDataSource])
void main() {
  late GPSCoordinateRepositoryImpl repository;
  late MockGPSCoordinateLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockGPSCoordinateLocalDataSource();
    repository = GPSCoordinateRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
  });

  final gpsEntity = GpsCoordinateEntity(
    id: 1,
    longitude: 10.0,
    latitude: 20.0,
    timestamp: DateTime.now(),
    altitude: 100.0,
    accuracy: 5.0,
  );

  final gpsModel = GpsCoordinateModel.fromEntity(gpsEntity);
  // A model version that would be returned by localDataSource after creation (with an ID)
  final gpsCreatedModel = GpsCoordinateModel.fromEntity(
    gpsModel.copyWith(id: 1),
  );

  group('createCoordinate', () {
    test(
      'should return Right<GpsCoordinateEntity> when localDataSource.createGPSCoordinate is successful',
      () async {
        when(
          mockLocalDataSource.createGPSCoordinate(any),
        ).thenAnswer((_) async => gpsCreatedModel);

        final result = await repository.createCoordinate(gpsEntity);

        expect(result, Right(gpsCreatedModel.toEntity()));
        verify(mockLocalDataSource.createGPSCoordinate(gpsModel));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return Left<CacheFailure> when localDataSource.createGPSCoordinate throws an Exception',
      () async {
        when(
          mockLocalDataSource.createGPSCoordinate(any),
        ).thenThrow(Exception('Database error'));

        final result = await repository.createCoordinate(gpsEntity);
        expect(
          result,
          const Left(
            CacheFailure(message: 'Failed to create coordiante locally.'),
          ),
        );
        verify(mockLocalDataSource.createGPSCoordinate(gpsModel));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );
  });

  group('getCoordinatesByDate', () {
    final dateTime = DateTime(2023, 7, 21);
    final gpsCoordinateModels = [
      GpsCoordinateModel(
        id: 1,
        longitude: 10.1,
        latitude: 20.1,
        timestamp: dateTime.add(const Duration(hours: 1)),
      ),
      GpsCoordinateModel(
        id: 2,
        longitude: 10.2,
        latitude: 20.2,
        timestamp: dateTime.add(const Duration(hours: 2)),
      ),
    ];
    final gpsCoordinateEntities = gpsCoordinateModels
        .map((e) => e.toEntity())
        .toList();

    test(
      'should return Right<List<GpsCoordinateEntity>> when localDataSource.getCoordinatesByDate is successful',
      () async {
        when(
          mockLocalDataSource.getCoordinatesByDate(dateTime),
        ).thenAnswer((_) async => gpsCoordinateModels);

        final result = await repository.getCoordinatesByDate(dateTime);

        expect(result.isRight(), true);
        result.fold((failure) => fail('Expected a Right but got a Left'), (
          actualEntities,
        ) {
          expect(
            const ListEquality().equals(actualEntities, gpsCoordinateEntities),
            true,
          );
        });
        verify(mockLocalDataSource.getCoordinatesByDate(dateTime));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return Left<CacheFailure> when localDataSource.getCoordinatesByDate throws an Exception',
      () async {
        when(
          mockLocalDataSource.getCoordinatesByDate(dateTime),
        ).thenThrow(Exception('Database error'));

        final result = await repository.getCoordinatesByDate(dateTime);
        expect(
          result,
          const Left(
            CacheFailure(
              message:
                  'Failed to retrieve coordinates by date from local database.',
            ),
          ),
        );
        verify(mockLocalDataSource.getCoordinatesByDate(dateTime));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );
  });

  group('getCoordinatesByDateRange', () {
    final dateRange = DateTimeRange(
      start: DateTime(2023, 7),
      end: DateTime(2023, 7, 31),
    );
    final gpsCoordinateModels = [
      GpsCoordinateModel(
        id: 1,
        longitude: 10.1,
        latitude: 20.1,
        timestamp: DateTime(2023, 7, 10),
      ),
      GpsCoordinateModel(
        id: 2,
        longitude: 10.2,
        latitude: 20.2,
        timestamp: DateTime(2023, 7, 20),
      ),
    ];
    final gpsCoordinateEntities = gpsCoordinateModels
        .map((e) => e.toEntity())
        .toList();

    test(
      'should return Right<List<GpsCoordinateEntity>> when localDataSource.getCoordinatesByDateRange is successful',
      () async {
        // Arrange
        when(
          mockLocalDataSource.getCoordinatesByDateRange(dateRange),
        ).thenAnswer((_) async => gpsCoordinateModels);

        final result = await repository.getCoordinatesByDateRange(dateRange);

        expect(result.isRight(), true);
        result.fold((failure) => fail('Expected a Right but got a Left'), (
          actualEntities,
        ) {
          expect(
            const ListEquality().equals(actualEntities, gpsCoordinateEntities),
            true,
          );
        });
        verify(mockLocalDataSource.getCoordinatesByDateRange(dateRange));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return Left<CacheFailure> when localDataSource.getCoordinatesByDateRange throws an Exception',
      () async {
        when(
          mockLocalDataSource.getCoordinatesByDateRange(dateRange),
        ).thenThrow(Exception('Database error'));

        final result = await repository.getCoordinatesByDateRange(dateRange);

        expect(
          result,
          const Left(
            CacheFailure(
              message: 'Failed to retrieve coordinates by daterange locally.',
            ),
          ),
        );
        verify(mockLocalDataSource.getCoordinatesByDateRange(dateRange));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );
  });

  group('updateCoordinate', () {
    final updatedGPSEntity = gpsEntity.copyWith(accuracy: 100);
    final updatedGPSModel = GpsCoordinateModel.fromEntity(updatedGPSEntity);
    const rowsAffected = 1;

    test(
      'should return Right<int> when localDataSource.updateCoordinate is successful',
      () async {
        // Arrange
        when(
          mockLocalDataSource.updateCoordinate(any),
        ).thenAnswer((_) async => rowsAffected);

        // Act
        final result = await repository.updateCoordinate(updatedGPSEntity);

        // Assert
        expect(result, const Right(rowsAffected));
        verify(mockLocalDataSource.updateCoordinate(updatedGPSModel));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return Left<CacheFailure> when localDataSource.updateCoordinate throws an Exception',
      () async {
        when(
          mockLocalDataSource.updateCoordinate(any),
        ).thenThrow(Exception('Database error'));

        final result = await repository.updateCoordinate(updatedGPSEntity);

        expect(
          result,
          const Left(
            CacheFailure(message: 'Failed to udpate coordiante locally.'),
          ),
        );
        verify(mockLocalDataSource.updateCoordinate(updatedGPSModel));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );
  });

  group('deleteCoordinate', () {
    const id = 1;
    const rowsAffected = 1;

    test(
      'should return Right<int> when localDataSource.deleteCoordinate is successful',
      () async {
        when(
          mockLocalDataSource.deleteCoordinate(id),
        ).thenAnswer((_) async => rowsAffected);

        final result = await repository.deleteCoordinate(id);

        expect(result, const Right(rowsAffected));
        verify(mockLocalDataSource.deleteCoordinate(id));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return Left<CacheFailure> when localDataSource.deleteCoordinate throws an Exception',
      () async {
        when(
          mockLocalDataSource.deleteCoordinate(id),
        ).thenThrow(Exception('Database error'));

        final result = await repository.deleteCoordinate(id);

        expect(
          result,
          const Left(
            CacheFailure(message: 'Failed to delete coordinate locally.'),
          ),
        );
        verify(mockLocalDataSource.deleteCoordinate(id));
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );
  });

  group('getLowestStoredDateTime', () {
    final lowesDateTime = DateTime(2022);

    test(
      'should return Right<DateTime> when localDataSource.getLowestStoredDateTime returns a DateTime',
      () async {
        when(
          mockLocalDataSource.getLowestStoredDateTime(),
        ).thenAnswer((_) async => lowesDateTime);

        final result = await repository.getLowestStoredDateTime();

        expect(result, Right(lowesDateTime));
        verify(mockLocalDataSource.getLowestStoredDateTime());
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return Left<CacheFailure> when localDataSource.getLowestStoredDateTime returns null',
      () async {
        when(
          mockLocalDataSource.getLowestStoredDateTime(),
        ).thenAnswer((_) async => null);

        final result = await repository.getLowestStoredDateTime();

        expect(
          result,
          const Left(
            CacheFailure(message: 'Failed to catch lowest DateTime locally.'),
          ),
        );
        verify(mockLocalDataSource.getLowestStoredDateTime());
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test(
      'should return Left<CacheFailure> when localDataSource.getLowestStoredDateTime throws an Exception',
      () async {
        when(
          mockLocalDataSource.getLowestStoredDateTime(),
        ).thenThrow(Exception('Database error'));

        final result = await repository.getLowestStoredDateTime();

        expect(
          result,
          const Left(
            CacheFailure(message: 'Failed to create coordiante locally.'),
          ),
        );
        verify(mockLocalDataSource.getLowestStoredDateTime());
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );
  });
}
