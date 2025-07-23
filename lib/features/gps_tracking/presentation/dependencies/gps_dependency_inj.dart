import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jourscape/features/gps_tracking/data/datasources/gps_coordinate_local_datasource.dart';
import 'package:jourscape/features/gps_tracking/data/repositories/gps_coordinate_repository_impl.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/create_gps_coordinate.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/delete_gps_coordinate.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/get_coordinates_by_date.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/get_coordinates_by_date_range.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/get_lowest_date_time.dart';
import 'package:jourscape/features/gps_tracking/domain/use_cases/udpate_gps_coordinate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'gps_dependency_inj.g.dart';

@riverpod
GpsCoordinateLocalDataSourceImpl gpsLocalDataSource(_) {
  return GpsCoordinateLocalDataSourceImpl();
}

@riverpod
GPSCoordinateRepositoryImpl gpsRepositoryImpl(Ref ref) {
  return GPSCoordinateRepositoryImpl(
    localDataSource: ref.watch(gpsLocalDataSourceProvider),
  );
}

@riverpod
GpsCoordinateRepository gpsRepository(Ref ref) {
  return ref.watch(gpsRepositoryImplProvider);
}

/// Use cases
@riverpod
CreateGPSCoordinate createGPSUseCase(Ref ref) {
  return CreateGPSCoordinate(repository: ref.watch(gpsRepositoryProvider));
}

@riverpod
DeleteGPSCoordinate updateGPSUseCase(Ref ref) {
  return DeleteGPSCoordinate(repository: ref.watch(gpsRepositoryProvider));
}

@riverpod
GetGPSCoordinateByDate getGPSByDateUseCase(Ref ref) {
  return GetGPSCoordinateByDate(repository: ref.watch(gpsRepositoryProvider));
}

@riverpod
GetGPSCoordinateByDateRange getGPSByDateRangeUseCase(Ref ref) {
  return GetGPSCoordinateByDateRange(
    repository: ref.watch(gpsRepositoryProvider),
  );
}

@riverpod
UpdateGPSCoordinate loginGPSUseCase(Ref ref) {
  return UpdateGPSCoordinate(repository: ref.watch(gpsRepositoryProvider));
}

@riverpod
GetLowestDateTime getLowestStoredDateTime(Ref ref) {
  return GetLowestDateTime(repository: ref.watch(gpsRepositoryProvider));
}
