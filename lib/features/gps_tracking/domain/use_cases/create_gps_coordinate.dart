import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';

class CreateGPSCoordinate
    implements UseCase<GpsCoordinateEntity, GpsCoordinateEntity> {
  final GpsCoordinateRepository repository;
  CreateGPSCoordinate({required this.repository});

  @override
  Future<Either<Failure, GpsCoordinateEntity>> call(
    GpsCoordinateEntity coordinate,
  ) async {
    return await repository.createCoordinate(coordinate);
  }
}
