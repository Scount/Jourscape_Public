import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/features/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> createUser(UserEntity user);
  Future<Either<Failure, UserEntity>> getUser(int id);
  Future<Either<Failure, int>> updateUser(UserEntity note);
  Future<Either<Failure, int>> deleteUser(int id);
  Future<Either<Failure, UserEntity>> loginUser(String name, String password);
  Future<Either<Failure, UserEntity>> registerUser(
    String name,
    String password,
  );
}
