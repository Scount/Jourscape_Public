import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/get_coordinates_by_date_range.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';

import 'get_coordinates_by_date_range_test.mocks.dart';

@GenerateMocks([GpsCoordinateRepository])
void main() {
  late GetGPSCoordinateByDateRange usecase;
  late MockGpsCoordinateRepository mockGpsCoordinateRepository;

  GpsCoordinateEntity tGpsEntity = GpsCoordinateEntity(
    id: 1,
    longitude: 10.0,
    latitude: 20.0,
    timestamp: DateTime(2023, 1, 1, 10),
  );

  GpsCoordinateEntity tGpsEntity2 = GpsCoordinateEntity(
    id: 2,
    longitude: 11.0,
    latitude: 21.0,
    timestamp: DateTime(2023, 7, 16, 11),
  );

  final List<GpsCoordinateEntity> tGpsEntities = [tGpsEntity, tGpsEntity2];

  final tDateRange = DateTimeRange(
    start: DateTime(2023, 7),
    end: DateTime(2023, 7, 31),
  );

  setUp(() {
    mockGpsCoordinateRepository = MockGpsCoordinateRepository();
    usecase = GetGPSCoordinateByDateRange(
      repository: mockGpsCoordinateRepository,
    );

    provideDummy<Either<Failure, List<GpsCoordinateEntity>>>(const Right([]));
  });

  group('GetGPSCoordinateByDateRange', () {
    test(
      'should call getCoordinatesByDateRange on the repository and return the list of entities on success',
      () async {
        when(
          mockGpsCoordinateRepository.getCoordinatesByDateRange(any),
        ).thenAnswer((_) async => Right(tGpsEntities));

        final result = await usecase(tDateRange);
        expect(result, Right(tGpsEntities));
        verify(
          mockGpsCoordinateRepository.getCoordinatesByDateRange(tDateRange),
        );
        verifyNoMoreInteractions(mockGpsCoordinateRepository);
      },
    );

    test(
      'should call getCoordinatesByDateRange on the repository and return the same Failure on failure',
      () async {
        const failure = CacheFailure(
          message: 'Failed to retrieve coordinates by date range.',
        );
        when(
          mockGpsCoordinateRepository.getCoordinatesByDateRange(any),
        ).thenAnswer((_) async => const Left(failure));
        final result = await usecase(tDateRange);
        expect(result, const Left(failure));
        verify(
          mockGpsCoordinateRepository.getCoordinatesByDateRange(tDateRange),
        );
        verifyNoMoreInteractions(mockGpsCoordinateRepository);
      },
    );
  });
}
