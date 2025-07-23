import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/user/domain/entities/user_entity.dart';
import 'package:jourscape/features/user/domain/repositories/user_repository.dart';

class UpdateUser implements UseCase<int, UserEntity> {
  final UserRepository repository;
  UpdateUser({required this.repository});

  @override
  Future<Either<Failure, int>> call(UserEntity user) async {
    return await repository.updateUser(user);
  }
}
