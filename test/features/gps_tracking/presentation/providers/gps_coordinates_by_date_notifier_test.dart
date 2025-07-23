import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/get_coordinates_by_date.dart';
import 'package:jourscape/features/gps_tracking/presentation/providers/gps_coordinates_by_date_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/presentation/dependencies/gps_dependency_inj.dart';

@GenerateMocks([GetGPSCoordinateByDate])
import 'gps_coordinates_by_date_notifier_test.mocks.dart';

void main() {
  late ProviderContainer container;
  late MockGetGPSCoordinateByDate mockGetGPSByDate;

  DateTime now = DateTime.now();
  DateTime nowNormalized = DateTime(now.year, now.month, now.day);
  final tGpsCoordinateEntity1 = GpsCoordinateEntity(
    id: 1,
    longitude: 10.0,
    latitude: 20.0,
    timestamp: nowNormalized,
  );
  final tGpsCoordinateEntity2 = GpsCoordinateEntity(
    id: 2,
    longitude: 11.0,
    latitude: 21.0,
    timestamp: nowNormalized.subtract(const Duration(days: 1)),
  );

  final tGpsCoordinateList = [tGpsCoordinateEntity1, tGpsCoordinateEntity2];

  setUp(() {
    mockGetGPSByDate = MockGetGPSCoordinateByDate();

    container = ProviderContainer(
      overrides: [
        getGPSByDateUseCaseProvider.overrideWithValue(mockGetGPSByDate),
      ],
    );

    provideDummy<Either<Failure, List<GpsCoordinateEntity>>>(const Right([]));
  });

  tearDown(() {
    container.dispose();
  });

  group('GpsCoordinatesByDateNotifier', () {
    test('initial state should be AsyncLoading', () {
      expect(
        container.read(gpsCoordinatesByDateNotifierProvider),
        isA<AsyncLoading>(),
      );
    });

    test(
      'should correctly fetch and set coordinates for a given date on success',
      () async {
        when(
          mockGetGPSByDate(nowNormalized),
        ).thenAnswer((_) async => Right(tGpsCoordinateList));

        final notifier = container.read(
          gpsCoordinatesByDateNotifierProvider.notifier,
        );
        await notifier.getCoordinatesByDate(nowNormalized);

        expect(notifier.state, isA<AsyncData<List<GpsCoordinateEntity>?>>());
        expect(notifier.state.value, tGpsCoordinateList);

        verify(mockGetGPSByDate(nowNormalized)).called(1);
        verifyNoMoreInteractions(mockGetGPSByDate);
      },
    );

    test(
      'should set state to AsyncData([]) when use case returns Left (failure)',
      () async {
        const tFailure = ServerFailure(
          message: 'Failed to retrieve coordinates from server.',
        );
        when(
          mockGetGPSByDate(nowNormalized),
        ).thenAnswer((_) async => const Left(tFailure));

        final notifier = container.read(
          gpsCoordinatesByDateNotifierProvider.notifier,
        );
        await notifier.getCoordinatesByDate(nowNormalized);
        expect(notifier.state, isA<AsyncData<List<GpsCoordinateEntity>?>>());
        expect(notifier.state.value, isEmpty);

        verify(mockGetGPSByDate(nowNormalized)).called(1);
        verifyNoMoreInteractions(mockGetGPSByDate);
      },
    );

    test(
      'should set state to AsyncError when an unexpected exception occurs',
      () async {
        final Exception testException = Exception('Network down!');
        when(mockGetGPSByDate(nowNormalized)).thenThrow(testException);
        final notifier = container.read(
          gpsCoordinatesByDateNotifierProvider.notifier,
        );
        await notifier.getCoordinatesByDate(nowNormalized);
        expect(notifier.state, isA<AsyncError>());
        expect(notifier.state.error, testException);
        expect(notifier.state.stackTrace, isNotNull);
        verify(mockGetGPSByDate(nowNormalized)).called(1);
        verifyNoMoreInteractions(mockGetGPSByDate);
      },
    );
  });
}
