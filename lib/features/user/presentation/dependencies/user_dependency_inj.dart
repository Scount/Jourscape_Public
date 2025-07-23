// Riverpod stuff
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jourscape/features/user/data/datasources/user_local_datasource.dart';
import 'package:jourscape/features/user/data/repositories/user_repository_impl.dart';
import 'package:jourscape/features/user/domain/repositories/user_repository.dart';
import 'package:jourscape/features/user/domain/use_cases/create_user.dart';
import 'package:jourscape/features/user/domain/use_cases/delete_user.dart';
import 'package:jourscape/features/user/domain/use_cases/get_user.dart';
import 'package:jourscape/features/user/domain/use_cases/login_user.dart';
import 'package:jourscape/features/user/domain/use_cases/update_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_dependency_inj.g.dart';

@riverpod
UserLocalDataSourceImpl userLocalDataSource(_) {
  return UserLocalDataSourceImpl();
}

@riverpod
UserRepositoryImpl userRepositoryImpl(Ref ref) {
  return UserRepositoryImpl(
    localDataSource: ref.watch(userLocalDataSourceProvider),
  );
}

@riverpod
UserRepository userRepository(Ref ref) {
  return ref.watch(userRepositoryImplProvider);
}

/// Use cases
@riverpod
CreateUser createUserUseCase(Ref ref) {
  return CreateUser(repository: ref.watch(userRepositoryProvider));
}

@riverpod
UpdateUser updateUserUseCase(Ref ref) {
  return UpdateUser(repository: ref.watch(userRepositoryProvider));
}

@riverpod
DeleteUser deleteUserUseCase(Ref ref) {
  return DeleteUser(repository: ref.watch(userRepositoryProvider));
}

@riverpod
GetUser getUserUseCase(Ref ref) {
  return GetUser(repository: ref.watch(userRepositoryProvider));
}

@riverpod
LoginUser loginUserUseCase(Ref ref) {
  return LoginUser(repository: ref.watch(userRepositoryProvider));
}
