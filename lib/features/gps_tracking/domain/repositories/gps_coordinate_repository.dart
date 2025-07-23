import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';

abstract class GpsCoordinateRepository {
  Future<Either<Failure, GpsCoordinateEntity>> createCoordinate(
    GpsCoordinateEntity coordinate,
  );
  Future<Either<Failure, List<GpsCoordinateEntity>>> getCoordinatesByDate(
    DateTime dateTime,
  );
  Future<Either<Failure, List<GpsCoordinateEntity>>> getCoordinatesByDateRange(
    DateTimeRange dateRange,
  );
  Future<Either<Failure, int>> updateCoordinate(GpsCoordinateEntity coordinate);
  Future<Either<Failure, int>> deleteCoordinate(int id);
  Future<Either<Failure, DateTime>> getLowestStoredDateTime();
}
