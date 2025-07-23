/// Abstract base class for all custom exceptions in the application.
///
/// This provides an interface for custom exceptions and allows for
/// a consistent way to add an optional message.
abstract class CustomException implements Exception {
  final String? message;

  const CustomException({this.message});

  @override
  String toString() {
    if (message == null) {
      return runtimeType.toString();
    }
    return '$runtimeType: $message';
  }
}

class ServerException extends CustomException {
  final int? statusCode;

  const ServerException({super.message, this.statusCode});

  @override
  String toString() {
    String base = super.toString();
    if (statusCode != null) {
      return '$base (Status Code: $statusCode)';
    }
    return base;
  }
}

class CacheException extends CustomException {
  const CacheException({super.message});
}

class NetworkException extends CustomException {
  const NetworkException({super.message});
}

class InvalidInputException extends CustomException {
  const InvalidInputException({super.message});
}

class AuthenticationException extends CustomException {
  const AuthenticationException({super.message});
}

class NotFoundException extends CustomException {
  const NotFoundException({super.message});
}

class UnknownException extends CustomException {
  const UnknownException({super.message});
}
