import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jourscape/core/error/failures.dart';

/// Abstract base class for all Use Cases.
///
/// It defines a standard `call` method that all concrete Use Cases must implement.
///
/// [Type] is the type of the value that will be returned on a successful call.
/// [Params] is the type of the parameters that the Use Case will receive.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// A special [NoParams] class for Use Cases that do not require any parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

/// A special [Params] class for Use Cases that only require a unique ID parameter.
class IdParams extends Equatable {
  final int id;

  const IdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

/// A special [LoginParams] class for Use Cases that require a two string parameter [name] nad [password].
class LoginParams extends Equatable {
  final String name;
  final String password;

  const LoginParams({required this.name, required this.password});

  @override
  List<Object?> get props => [name, password];
}
