import 'package:jourscape/features/user/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class UserLocalDataSource {
  Future<void> initDatabase();
  Future<UserModel> createUser(UserModel note);
  Future<UserModel> getUser(int id);
  Future<int> updateUser(UserModel note);
  Future<int> deleteUser(int id);
  Future<void> closeDatabase();
  Future<UserModel> loginUser(String name, String password);
  Future<UserModel> registerUser(String name, String password);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'users.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
      CREATE TABLE ${UserFields.tableName} (
        ${UserFields.id} ${UserFields.idType},
        ${UserFields.name} ${UserFields.textType},
        ${UserFields.email} ${UserFields.textType},
        ${UserFields.passwordHash} ${UserFields.textType},
        ${UserFields.createdAt} ${UserFields.intType}
      )
    ''');
  }

  @override
  Future<void> initDatabase() async {
    await database;
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    final db = await database;
    final id = await db.insert(UserFields.tableName, user.toCreateJson());
    return UserModel.fromEntity(user.toEntity().copyWith(id: id));
  }

  @override
  Future<UserModel> getUser(int id) async {
    final db = await database;
    final maps = await db.query(
      UserFields.tableName,
      columns: UserFields.values,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  @override
  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return db.update(
      UserFields.tableName,
      user.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      UserFields.tableName,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<UserModel> loginUser(String name, String password) async {
    final db = await database;
    final maps = await db.query(
      UserFields.tableName,
      columns: UserFields.values,
      where: '${UserFields.name} = ? AND ${UserFields.passwordHash} = ?',
      whereArgs: [name, password],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    } else {
      throw Exception('ID $name not found');
    }
  }

  @override
  Future<UserModel> registerUser(String name, String password) async {
    final db = await database;
    final maps = await db.query(
      UserFields.tableName,
      columns: UserFields.values,
      where: '${UserFields.name} = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    } else {
      throw Exception('ID $name not found');
    }
  }

  @override
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
