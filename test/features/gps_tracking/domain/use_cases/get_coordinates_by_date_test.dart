import 'package:flutter_test/flutter_test.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/get_coordinates_by_date.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';

import 'get_coordinates_by_date_test.mocks.dart';

@GenerateMocks([GpsCoordinateRepository])
void main() {
  late GetGPSCoordinateByDate usecase;
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

  final tDateTime = DateTime(2023, 7, 15);

  setUp(() {
    mockGpsCoordinateRepository = MockGpsCoordinateRepository();
    usecase = GetGPSCoordinateByDate(repository: mockGpsCoordinateRepository);
    provideDummy<Either<Failure, List<GpsCoordinateEntity>>>(const Right([]));
  });

  group('GetGPSCoordinateByDate', () {
    test(
      'should call getCoordinatesByDate on the repository and return the list of entities on success',
      () async {
        when(
          mockGpsCoordinateRepository.getCoordinatesByDate(any),
        ).thenAnswer((_) async => Right(tGpsEntities));
        final result = await usecase(tDateTime);
        expect(result, Right(tGpsEntities));
        verify(mockGpsCoordinateRepository.getCoordinatesByDate(tDateTime));
        verifyNoMoreInteractions(mockGpsCoordinateRepository);
      },
    );

    test(
      'should call getCoordinatesByDate on the repository and return the same Failure on failure',
      () async {
        const failure = CacheFailure(
          message: 'Failed to retrieve coordinates by date.',
        );
        when(
          mockGpsCoordinateRepository.getCoordinatesByDate(any),
        ).thenAnswer((_) async => const Left(failure));
        final result = await usecase(tDateTime);
        expect(result, const Left(failure));
        verify(mockGpsCoordinateRepository.getCoordinatesByDate(tDateTime));
        verifyNoMoreInteractions(mockGpsCoordinateRepository);
      },
    );
  });
}
