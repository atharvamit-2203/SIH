import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sihapp.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create user table
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
        // Create scores table
        await db.execute('''
          CREATE TABLE scores (
            id INTEGER PRIMARY KEY,
            user_id INTEGER,
            game_name TEXT,
            score INTEGER,
            FOREIGN KEY (user_id) REFERENCES users (id)
          )
        ''');
      },
    );
  }

  // --- User-related methods ---

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
  
  // --- Score-related methods ---

  Future<int> insertScore(Map<String, dynamic> score) async {
    final db = await database;
    return await db.insert('scores', score, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getHighScores(String gameName) async {
    final db = await database;
    return await db.query(
      'scores',
      where: 'game_name = ?',
      whereArgs: [gameName],
      orderBy: 'score DESC',
      limit: 10,
    );
  }
}