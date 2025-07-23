import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/presentation/dependencies/gps_dependency_inj.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gps_all_coordinates_notifier.g.dart';

@riverpod
class GpsAllCoordinatesNotifier extends _$GpsAllCoordinatesNotifier {
  DateTime? lowestDate;

  @override
  AsyncValue<List<List<GpsCoordinateEntity>?>> build() {
    return const AsyncLoading();
  }

  // Method to fetch coordinates for a specific date
  Future<void> getAllCoordinates() async {
    try {
      final getLowestDateTime = ref.read(getLowestStoredDateTimeProvider);
      final dateTimeResult = await getLowestDateTime(const NoParams());
      await dateTimeResult.fold(
        (onLeft) {
          return;
        },
        (onRight) async {
          lowestDate = onRight;
          DateTime now = DateTime.now();
          DateTime nowNormalized = DateTime(now.year, now.month, now.day);
          int dayDifference = now.difference(lowestDate!).inDays;
          List<List<GpsCoordinateEntity>?> currentState = List.of(
            state.value ?? [],
          );
          for (int i = 0; i <= dayDifference; i++) {
            final getCoordinatesByDate = ref.read(getGPSByDateUseCaseProvider);
            final coordinates = await getCoordinatesByDate(
              nowNormalized.subtract(Duration(days: i)),
            );
            coordinates.fold((onLeft) {}, (onRight) {
              currentState.add(onRight);
              state = AsyncData(currentState);
            });
          }
        },
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
