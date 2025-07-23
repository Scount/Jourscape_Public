import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';

class GetLowestDateTime implements UseCase<DateTime, NoParams> {
  final GpsCoordinateRepository repository;
  GetLowestDateTime({required this.repository});

  @override
  Future<Either<Failure, DateTime>> call(_) async {
    return await repository.getLowestStoredDateTime();
  }
}
