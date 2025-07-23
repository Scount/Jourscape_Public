import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._internal();

  static Database? _database;

  LocalDatabase._internal();

  /// Check if a the database already set
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'notes.db');
      return await openDatabase(path, version: 1, onCreate: _createDatabase);
    } catch (e) {
      throw Exception('Database cannot be found or cannot be initialized');
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          created_time INTEGER NOT NULL
        )
      ''');
  }

  Future open(String path) async {
    // TODO(Thorben): Put database version number to launch json
    _database = await openDatabase(path, version: 1, onCreate: _createDatabase);
  }
}
