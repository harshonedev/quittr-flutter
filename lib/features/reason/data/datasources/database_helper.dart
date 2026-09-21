import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/reason_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reasons.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    } catch (e) {
      // Handle any errors that might occur during database initialization
      debugPrint('Database initialization error: $e');
      rethrow;
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reasons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reason TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<ReasonModel> create(ReasonModel reason) async {
    final db = await instance.database;
    final id = await db.insert('reasons', reason.toMap());
    return reason.copyWith(id: id.toString());
  }

  Future<List<ReasonModel>> getAllReasons() async {
    final db = await instance.database;
    final result = await db.query('reasons', orderBy: 'created_at DESC');
    return result.map((json) => ReasonModel.fromMap(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'reasons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
