import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';
import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/user/domain/repositories/user_repository.dart';

class DeleteUser implements UseCase<int, int> {
  final UserRepository repository;
  DeleteUser({required this.repository});

  @override
  Future<Either<Failure, int>> call(int id) async {
    return await repository.deleteUser(id);
  }
}
