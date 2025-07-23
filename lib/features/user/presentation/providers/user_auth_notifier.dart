import 'package:jourscape/core/usecases/usecase.dart';
import 'package:jourscape/features/user/domain/entities/user_entity.dart';
import 'package:jourscape/features/user/domain/use_cases/create_user.dart';
import 'package:jourscape/features/user/domain/use_cases/login_user.dart';
import 'package:jourscape/features/user/presentation/dependencies/user_dependency_inj.dart';
import 'package:jourscape/features/user/presentation/providers/user_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final LoginUser _loginUser;
  late final CreateUser _createUser;
  late final CurrentUser? _currentUserNotifier;

  @override
  AsyncValue<UserEntity?> build() {
    _loginUser = ref.read(loginUserUseCaseProvider);
    _createUser = ref.read(createUserUseCaseProvider);
    _currentUserNotifier = ref.read(currentUserProvider.notifier);
    return const AsyncData(null);
  }

  // Method to handle the anonymous login/create logic
  Future<void> loginAnonymously() async {
    state = const AsyncLoading();

    // Attempt to log in
    final loginResult = await _loginUser(
      const LoginParams(name: 'Anonym', password: 'Anonym'),
    );

    loginResult.fold(
      // Left side: Login Failed
      (loginFailure) async {
        // If login failed, try to create the user
        final createUserResult = await _createUser(
          UserEntity(
            id: 1,
            name: 'Anonym',
            passwordHash: 'Anonym',
            email: 'anonym.anonym@anonym.anonym',
            createdAt: DateTime.now(),
          ),
        );

        createUserResult.fold(
          (createFailure) {
            state = AsyncError(createFailure, StackTrace.current);
          },
          (newUser) {
            _currentUserNotifier?.setUser(newUser);
            state = AsyncData(newUser);
          },
        );
      },
      // Right side: Login Success
      (loggedInUser) {
        _currentUserNotifier?.setUser(loggedInUser);
        state = AsyncData(loggedInUser);
      },
    );
  }

  // Method to handle the login logic
  Future<void> loginUser(String name, String password) async {
    state = const AsyncLoading();

    // Attempt to log in
    final loginResult = await _loginUser(
      LoginParams(name: name, password: password),
    );

    loginResult.fold(
      // Left side: Login Failed
      (loginFailure) async {
        _currentUserNotifier?.setUser(null);
        state = const AsyncData(null);
      },
      // Right side: Login Success
      (loggedInUser) {
        _currentUserNotifier?.setUser(loggedInUser);
        state = AsyncData(loggedInUser);
      },
    );
  }

  // Method for logout
  Future<void> logout() async {
    state = const AsyncLoading();
    _currentUserNotifier?.setUser(null);
    state = const AsyncData(null);
  }
}
