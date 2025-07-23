import 'package:jourscape/features/user/domain/entities/user_entity.dart';

class UserFields {
  static const String tableName = 'users';
  static const String id = '_id';
  static const String name = 'name';
  static const String email = 'email';
  static const String passwordHash = 'passwordHash';
  static const String createdAt = 'createdAt';

  static final List<String> values = [id, name, createdAt, email, passwordHash];

  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String intType = 'INTEGER NOT NULL';
  static const String textType = 'TEXT NOT NULL';
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.passwordHash,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[UserFields.id] as int,
      name: json[UserFields.name] as String,
      email: json[UserFields.email] as String,
      passwordHash: json[UserFields.passwordHash] as String,
      createdAt: DateTime.parse(json[UserFields.createdAt] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      UserFields.id: id,
      UserFields.name: name,
      UserFields.email: email,
      UserFields.passwordHash: passwordHash,
      UserFields.createdAt: createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      UserFields.id: null,
      UserFields.name: name,
      UserFields.email: email,
      UserFields.passwordHash: passwordHash,
      UserFields.createdAt: createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      passwordHash: entity.passwordHash,
      createdAt: entity.createdAt,
    );
  }

  UserEntity toEntity() => this;
}
