import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/get_coordinates_by_date.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/get_lowest_date_time.dart';
import 'package:jourscape/features/gps_tracking/presentation/providers/gps_all_coordinates_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/presentation/dependencies/gps_dependency_inj.dart';

@GenerateMocks([GetLowestDateTime, GetGPSCoordinateByDate])
import 'gps_all_coordinates_notifier_test.mocks.dart';

void main() {
  late ProviderContainer container;
  late MockGetLowestDateTime mockGetLowestDateTime;
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
  final tGpsCoordinateEntity3 = GpsCoordinateEntity(
    id: 3,
    longitude: 12.0,
    latitude: 22.0,
    timestamp: nowNormalized.subtract(const Duration(days: 2)),
  );

  setUp(() {
    mockGetLowestDateTime = MockGetLowestDateTime();
    mockGetGPSByDate = MockGetGPSCoordinateByDate();

    container = ProviderContainer(
      overrides: [
        getLowestStoredDateTimeProvider.overrideWithValue(
          mockGetLowestDateTime,
        ),
        getGPSByDateUseCaseProvider.overrideWithValue(mockGetGPSByDate),
      ],
    );

    provideDummy<Either<Failure, DateTime>>(Right(nowNormalized));
    provideDummy<Either<Failure, List<GpsCoordinateEntity>>>(const Right([]));
  });

  tearDown(() {
    container.dispose();
  });

  group('GpsAllCoordinatesNotifier', () {
    test('initial state should be AsyncLoading', () {
      expect(
        container.read(gpsAllCoordinatesNotifierProvider),
        isA<AsyncLoading>(),
      );
    });

    test(
      'should correctly fetch and set coordinates for all days from lowest date to now',
      () async {
        final lowestDate = nowNormalized.subtract(const Duration(days: 2));

        when(
          mockGetLowestDateTime(const NoParams()),
        ).thenAnswer((_) async => Right(lowestDate));
        when(
          mockGetGPSByDate(nowNormalized),
        ).thenAnswer((_) async => Right([tGpsCoordinateEntity1]));
        when(
          mockGetGPSByDate(nowNormalized.subtract(const Duration(days: 1))),
        ).thenAnswer((_) async => Right([tGpsCoordinateEntity2]));
        when(
          mockGetGPSByDate(nowNormalized.subtract(const Duration(days: 2))),
        ).thenAnswer((_) async => Right([tGpsCoordinateEntity3]));

        final notifier = container.read(
          gpsAllCoordinatesNotifierProvider.notifier,
        );
        await notifier.getAllCoordinates();

        expect(
          notifier.state,
          isA<AsyncData<List<List<GpsCoordinateEntity>?>>>(),
        );

        expect(notifier.lowestDate, lowestDate);
        expect(notifier.state.value!.length, 3);
        expect(notifier.state.value![0], [tGpsCoordinateEntity1]);
        expect(notifier.state.value![1], [tGpsCoordinateEntity2]);
        expect(notifier.state.value![2], [tGpsCoordinateEntity3]);

        verify(mockGetLowestDateTime(const NoParams())).called(1);
        verify(
          mockGetGPSByDate(nowNormalized.subtract(const Duration(days: 0))),
        ).called(1);
        verify(
          mockGetGPSByDate(nowNormalized.subtract(const Duration(days: 1))),
        ).called(1);
        verify(
          mockGetGPSByDate(nowNormalized.subtract(const Duration(days: 2))),
        ).called(1);
        verifyNoMoreInteractions(mockGetLowestDateTime);
        verifyNoMoreInteractions(mockGetGPSByDate);
      },
    );

    test(
      'should set state to AsyncError when getLowestDateTime fails',
      () async {
        const tFailure = CacheFailure(message: 'Failed to get lowest date');
        when(
          mockGetLowestDateTime(any),
        ).thenAnswer((_) async => const Left(tFailure));

        final notifier = container.read(
          gpsAllCoordinatesNotifierProvider.notifier,
        );
        await notifier.getAllCoordinates();

        expect(notifier.state, isA<AsyncLoading>());
        expect(notifier.lowestDate, isNull);
        verify(mockGetLowestDateTime(const NoParams())).called(1);
        verifyZeroInteractions(mockGetGPSByDate);
      },
    );

    test(
      'should handle getGPSByDateUseCase failures gracefully (skip that day) and set AsyncError if an exception occurs',
      () async {
        final lowestDate = nowNormalized.subtract(const Duration(days: 2));

        when(
          mockGetLowestDateTime(const NoParams()),
        ).thenAnswer((_) async => Right(lowestDate));

        when(
          mockGetGPSByDate(nowNormalized.subtract(const Duration(days: 0))),
        ).thenAnswer((_) async => Right([tGpsCoordinateEntity1]));
        when(
          mockGetGPSByDate(nowNormalized.subtract(const Duration(days: 1))),
        ).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'DB error')),
        );
        when(
          mockGetGPSByDate(nowNormalized.subtract(const Duration(days: 2))),
        ).thenAnswer((_) async => Right([tGpsCoordinateEntity3]));

        final notifier = container.read(
          gpsAllCoordinatesNotifierProvider.notifier,
        );
        await notifier.getAllCoordinates();

        expect(
          notifier.state,
          isA<AsyncData<List<List<GpsCoordinateEntity>?>>>(),
        );
        expect(notifier.state.value!.length, 2);
        expect(notifier.state.value![0], [tGpsCoordinateEntity1]);
        expect(notifier.state.value![1], [tGpsCoordinateEntity3]);

        verify(mockGetLowestDateTime(const NoParams())).called(1);
        verify(mockGetGPSByDate(any)).called(3);
        verifyNoMoreInteractions(mockGetLowestDateTime);
        verifyNoMoreInteractions(mockGetGPSByDate);
      },
    );

    test(
      'should set state to AsyncError when an unexpected exception occurs',
      () async {
        when(
          mockGetLowestDateTime(any),
        ).thenThrow(Exception('Simulated network error'));

        final notifier = container.read(
          gpsAllCoordinatesNotifierProvider.notifier,
        );
        await notifier.getAllCoordinates();

        expect(notifier.state, isA<AsyncError>());
        expect(notifier.state.error, isA<Exception>());
        expect(
          (notifier.state.error as Exception).toString(),
          contains('Simulated network error'),
        );
        expect(notifier.lowestDate, isNull);

        verify(mockGetLowestDateTime(const NoParams())).called(1);
        verifyZeroInteractions(mockGetGPSByDate);
      },
    );
  });
}
