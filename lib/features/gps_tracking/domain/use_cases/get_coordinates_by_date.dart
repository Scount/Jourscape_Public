import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';

class GetGPSCoordinateByDate
    implements UseCase<List<GpsCoordinateEntity>, DateTime> {
  final GpsCoordinateRepository repository;
  GetGPSCoordinateByDate({required this.repository});

  @override
  Future<Either<Failure, List<GpsCoordinateEntity>>> call(
    DateTime dateTime,
  ) async {
    return await repository.getCoordinatesByDate(dateTime);
  }
}
