import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';

class DeleteGPSCoordinate implements UseCase<int, int> {
  final GpsCoordinateRepository repository;
  DeleteGPSCoordinate({required this.repository});

  @override
  Future<Either<Failure, int>> call(int id) async {
    return await repository.deleteCoordinate(id);
  }
}
