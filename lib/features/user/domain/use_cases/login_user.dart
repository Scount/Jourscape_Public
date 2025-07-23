import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/user/domain/entities/user_entity.dart';
import 'package:jourscape/features/user/domain/repositories/user_repository.dart';

class LoginUser implements UseCase<UserEntity, LoginParams> {
  final UserRepository repository;
  LoginUser({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.loginUser(params.name, params.password);
  }
}
