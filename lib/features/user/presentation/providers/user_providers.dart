import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jourscape/features/user/domain/entities/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_providers.g.dart';

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  UserEntity? build() {
    return null;
  }

  void setUser(UserEntity? user) {
    state = user;
  }
}

@riverpod
int? currentUserId(Ref ref) {
  return ref.watch(currentUserProvider)?.id;
}
