import 'package:flutter_test/flutter_test.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/udpate_gps_coordinate.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';

import 'udpate_gps_coordinate_test.mocks.dart';

@GenerateMocks([GpsCoordinateRepository])
void main() {
  late UpdateGPSCoordinate usecase;
  late MockGpsCoordinateRepository mockGpsCoordinateRepository;

  GpsCoordinateEntity tGpsEntity = GpsCoordinateEntity(
    id: 1,
    longitude: 10.0,
    latitude: 20.0,
    timestamp: DateTime(2023, 1, 1, 10),
  );

  setUp(() {
    mockGpsCoordinateRepository = MockGpsCoordinateRepository();
    usecase = UpdateGPSCoordinate(repository: mockGpsCoordinateRepository);
    provideDummy<Either<Failure, int>>(const Right(0));
  });

  group('UpdateGPSCoordinate', () {
    test(
      'should call updateCoordinate on the repository and return the number of affected rows on success',
      () async {
        const rowsAffected = 1;
        when(
          mockGpsCoordinateRepository.updateCoordinate(any),
        ).thenAnswer((_) async => const Right(rowsAffected));
        final result = await usecase(tGpsEntity);
        expect(result, const Right(rowsAffected));
        verify(mockGpsCoordinateRepository.updateCoordinate(tGpsEntity));
        verifyNoMoreInteractions(mockGpsCoordinateRepository);
      },
    );

    test(
      'should call updateCoordinate on the repository and return the same Failure on failure',
      () async {
        const failure = CacheFailure(
          message: 'Failed to update GPS coordinate in data source.',
        );
        when(
          mockGpsCoordinateRepository.updateCoordinate(any),
        ).thenAnswer((_) async => const Left(failure));
        final result = await usecase(tGpsEntity);
        expect(result, const Left(failure));
        verify(mockGpsCoordinateRepository.updateCoordinate(tGpsEntity));
        verifyNoMoreInteractions(mockGpsCoordinateRepository);
      },
    );
  });
}
