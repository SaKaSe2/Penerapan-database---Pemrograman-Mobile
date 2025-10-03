import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE users (
        id $idType,
        nama $textType,
        nim $textType UNIQUE,
        alamat $textType,
        noWa $textType,
        email $textType UNIQUE,
        password $textType
      )
    ''');
  }

  Future<User> createUser(User user) async {
    final db = await instance.database;
    final id = await db.insert('users', user.toMap());
    return user.copy(id: id);
  }

  Future<User?> login(String nim, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'nim = ? AND password = ?',
      whereArgs: [nim, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> checkNimExists(String nim) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'nim = ?',
      whereArgs: [nim],
    );
    return result.isNotEmpty;
  }

  Future<bool> checkEmailExists(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}