import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/features/user/data/datasources/user_local_datasource.dart';
import 'package:jourscape/features/user/data/models/user_model.dart';
import 'package:jourscape/features/user/domain/entities/user_entity.dart';
import 'package:jourscape/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> createUser(UserEntity note) async {
    try {
      final noteModel = UserModel.fromEntity(note);
      final createdNoteModel = await localDataSource.createUser(noteModel);
      return Right(createdNoteModel.toEntity());
    } on Exception {
      return const Left(
        CacheFailure(message: 'Failed to create user locally.'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUser(int id) async {
    try {
      final noteModel = await localDataSource.getUser(id);
      return Right(noteModel.toEntity());
    } on Exception {
      return const Left(
        CacheFailure(message: 'Failed to retrieve user from local database.'),
      );
    }
  }

  @override
  Future<Either<Failure, int>> updateUser(UserEntity note) async {
    try {
      final noteModel = UserModel.fromEntity(note);
      final rowsAffected = await localDataSource.updateUser(noteModel);
      return Right(rowsAffected);
    } on Exception {
      return const Left(
        CacheFailure(message: 'Failed to update user locally.'),
      );
    }
  }

  @override
  Future<Either<Failure, int>> deleteUser(int id) async {
    try {
      final rowsAffected = await localDataSource.deleteUser(id);
      return Right(rowsAffected);
    } on Exception {
      return const Left(
        CacheFailure(message: 'Failed to delete user locally.'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginUser(
    String name,
    String password,
  ) async {
    try {
      final rowsAffected = await localDataSource.loginUser(name, password);
      return Right(rowsAffected);
    } on Exception {
      return const Left(CacheFailure(message: 'Failed to login user locally.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerUser(
    String name,
    String password,
  ) async {
    try {
      final rowsAffected = await localDataSource.registerUser(name, password);
      return Right(rowsAffected);
    } on Exception {
      return const Left(
        CacheFailure(message: 'Failed to register user locally.'),
      );
    }
  }
}
