import 'package:flutter_test/flutter_test.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/get_lowest_date_time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/core/usecases/usecase.dart';

import 'get_lowest_date_time_test.mocks.dart';

@GenerateMocks([GpsCoordinateRepository])
void main() {
  late GetLowestDateTime usecase;
  late MockGpsCoordinateRepository mockGpsCoordinateRepository;

  setUp(() {
    mockGpsCoordinateRepository = MockGpsCoordinateRepository();
    usecase = GetLowestDateTime(repository: mockGpsCoordinateRepository);

    provideDummy<Either<Failure, DateTime>>(Right(DateTime(2000)));
  });

  final lowestDateTime = DateTime(2022);

  group('GetLowestDateTime', () {
    test(
      'should call getLowestStoredDateTime on the repository and return the DateTime on success',
      () async {
        when(
          mockGpsCoordinateRepository.getLowestStoredDateTime(),
        ).thenAnswer((_) async => Right(lowestDateTime));
        final result = await usecase(const NoParams());
        expect(result, Right(lowestDateTime));
        verify(mockGpsCoordinateRepository.getLowestStoredDateTime());
        verifyNoMoreInteractions(mockGpsCoordinateRepository);
      },
    );

    test(
      'should call getLowestStoredDateTime on the repository and return the same Failure on failure',
      () async {
        const tFailure = CacheFailure(
          message: 'Failed to retrieve lowest DateTime.',
        );
        when(
          mockGpsCoordinateRepository.getLowestStoredDateTime(),
        ).thenAnswer((_) async => const Left(tFailure));
        final result = await usecase(const NoParams());
        expect(result, const Left(tFailure));
        verify(mockGpsCoordinateRepository.getLowestStoredDateTime());
        verifyNoMoreInteractions(mockGpsCoordinateRepository);
      },
    );
  });
}
