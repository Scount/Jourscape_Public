import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/features/gps_tracking/data/datasources/gps_coordinate_local_datasource.dart';
import 'package:jourscape/features/gps_tracking/data/models/gps_coordinate_model.dart';
import 'package:jourscape/features/gps_tracking/domain/entities/gps_coordinate_entitiy.dart';
import 'package:jourscape/features/gps_tracking/domain/repositories/gps_coordinate_repository.dart';

class GPSCoordinateRepositoryImpl implements GpsCoordinateRepository {
  final GPSCoordinateLocalDataSource localDataSource;

  GPSCoordinateRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, GpsCoordinateEntity>> createCoordinate(
    GpsCoordinateEntity coordinate,
  ) async {
    try {
      final coordinateModel = GpsCoordinateModel.fromEntity(coordinate);
      final createdCoordinateModel = await localDataSource.createGPSCoordinate(
        coordinateModel,
      );
      return Right(createdCoordinateModel.toEntity());
    } on Exception {
      return const Left(
        CacheFailure(message: 'Failed to create coordiante locally.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<GpsCoordinateEntity>>> getCoordinatesByDate(
    DateTime dateTime,
  ) async {
    try {
      final coordinatesModel = await localDataSource.getCoordinatesByDate(
        dateTime,
      );

      return Right(
        List<GpsCoordinateEntity>.from(
          coordinatesModel.map((e) => e.toEntity()).toList(),
        ),
      );
    } on Exception {
      return const Left(
        CacheFailure(
          message:
              'Failed to retrieve coordinates by date from local database.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<GpsCoordinateEntity>>> getCoordinatesByDateRange(
    DateTimeRange dateRange,
  ) async {
    try {
      final coordinatesModel = await localDataSource.getCoordinatesByDateRange(
        dateRange,
      );
      return Right(coordinatesModel.map((e) => e.toEntity()).toList());
    } on Exception {
      return const Left(
        CacheFailure(
          message: 'Failed to retrieve coordinates by daterange locally.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, int>> updateCoordinate(
    GpsCoordinateEntity coordinate,
  ) async {
    try {
      final coordinateModel = GpsCoordinateModel.fromEntity(coordinate);

      final rowsAffected = await localDataSource.updateCoordinate(
        coordinateModel,
      );
      return Right(rowsAffected);
    } on Exception {
      return const Left(
        CacheFailure(message: 'Failed to udpate coordiante locally.'),
      );
    }
  }

  @override
  Future<Either<Failure, int>> deleteCoordinate(int id) async {
    try {
      final rowsAffected = await localDataSource.deleteCoordinate(id);
      return Right(rowsAffected);
    } on Exception {
      return const Left(
        CacheFailure(message: 'Failed to delete coordinate locally.'),
      );
    }
  }

  @override
  Future<Either<Failure, DateTime>> getLowestStoredDateTime() async {
    try {
      final lowestDateTime = await localDataSource.getLowestStoredDateTime();
      if (lowestDateTime != null) {
        return Right(lowestDateTime);
      } else {
        return const Left(
          CacheFailure(message: 'Failed to catch lowest DateTime locally.'),
        );
      }
    } on Exception {
      return const Left(
        CacheFailure(message: 'Failed to create coordiante locally.'),
      );
    }
  }
}
