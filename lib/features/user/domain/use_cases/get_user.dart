import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/user/domain/entities/user_entity.dart';
import 'package:jourscape/features/user/domain/repositories/user_repository.dart';

class GetUser implements UseCase<UserEntity, int> {
  final UserRepository repository;
  GetUser({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(int id) async {
    return await repository.getUser(id);
  }
}
