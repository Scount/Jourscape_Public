import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;

  const Failure({this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({super.message});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message});
}
