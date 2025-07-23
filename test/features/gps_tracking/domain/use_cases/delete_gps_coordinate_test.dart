import 'package:flutter_test/flutter_test.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/delete_gps_coordinate.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';

import 'delete_gps_coordinate_test.mocks.dart';

@GenerateMocks([GpsCoordinateRepository])
void main() {
  late DeleteGPSCoordinate usecase;
  late MockGpsCoordinateRepository mockGpsCoordinateRepository;

  setUp(() {
    mockGpsCoordinateRepository = MockGpsCoordinateRepository();
    usecase = DeleteGPSCoordinate(repository: mockGpsCoordinateRepository);

    provideDummy<Either<Failure, int>>(const Right(0));
  });

  const toBeDeletedId = 123;

  group('DeleteGPSCoordinate', () {
    test(
      'should call deleteCoordinate on the repository and return the same int on success',
      () async {
        const rowsAffected = 1;
        when(
          mockGpsCoordinateRepository.deleteCoordinate(any),
        ).thenAnswer((_) async => const Right(rowsAffected));

        final result = await usecase(toBeDeletedId);
        expect(result, const Right(rowsAffected));
        verify(mockGpsCoordinateRepository.deleteCoordinate(toBeDeletedId));
        verifyNoMoreInteractions(mockGpsCoordinateRepository);
      },
    );

    test(
      'should call deleteCoordinate on the repository and return the same Failure on failure',
      () async {
        const failure = CacheFailure(
          message: 'Failed to delete GPS coordinate in data source.',
        );
        when(
          mockGpsCoordinateRepository.deleteCoordinate(any),
        ).thenAnswer((_) async => const Left(failure));
        final result = await usecase(toBeDeletedId);
        expect(result, const Left(failure));
        verify(mockGpsCoordinateRepository.deleteCoordinate(toBeDeletedId));
        verifyNoMoreInteractions(mockGpsCoordinateRepository);
      },
    );
  });
}
