import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/presentation/dependencies/gps_dependency_inj.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gps_coordinates_by_date_notifier.g.dart';

@riverpod
class GpsCoordinatesByDateNotifier extends _$GpsCoordinatesByDateNotifier {
  @override
  AsyncValue<List<GpsCoordinateEntity>?> build() {
    return const AsyncLoading();
  }

  Future<void> getCoordinatesByDate(DateTime date) async {
    try {
      final getCoordinatesByDate = ref.read(getGPSByDateUseCaseProvider);
      final coordinates = await getCoordinatesByDate(date);
      coordinates.fold(
        (onLeft) {
          state = const AsyncData([]);
        },
        (onRight) {
          state = AsyncData(onRight);
        },
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
