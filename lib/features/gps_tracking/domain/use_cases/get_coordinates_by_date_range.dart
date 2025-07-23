import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';

class GetGPSCoordinateByDateRange
    implements UseCase<List<GpsCoordinateEntity>, DateTimeRange> {
  final GpsCoordinateRepository repository;
  GetGPSCoordinateByDateRange({required this.repository});

  @override
  Future<Either<Failure, List<GpsCoordinateEntity>>> call(
    DateTimeRange dateTime,
  ) async {
    return await repository.getCoordinatesByDateRange(dateTime);
  }
}
