import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quittr/features/journal/data/models/journal_entry_model.dart';
import 'package:quittr/features/reason/data/models/reason_model.dart';

class DatabaseHelper {
  static const _databaseName = "quittr.db";
  static const _databaseVersion = 1;

  // Table names
  static const settingsTable = 'settings';
  static const reasonsTable = 'reasons';
  static const journalEntriesTable = 'journal_entries';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Settings table
    await db.execute('''
      CREATE TABLE $settingsTable (
        id INTEGER PRIMARY KEY,
        isDarkMode INTEGER NOT NULL,
        enableNotifications INTEGER NOT NULL,
        language TEXT NOT NULL
      )
    ''');

    // Reasons table
    await db.execute('''
      CREATE TABLE $reasonsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reason TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Journal entries table
    await db.execute('''
      CREATE TABLE $journalEntriesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // Reason-related methods
  Future<ReasonModel> createReason(ReasonModel reason) async {
    final db = await database;
    final id = await db.insert(reasonsTable, reason.toMap());
    return reason.copyWith(id: id.toString());
  }

  Future<List<ReasonModel>> getAllReasons() async {
    final db = await database;
    final result = await db.query(reasonsTable, orderBy: 'created_at DESC');
    return result.map((json) => ReasonModel.fromMap(json)).toList();
  }

  Future<int> deleteReason(int id) async {
    final db = await database;
    return await db.delete(
      reasonsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Journal-related methods
  Future<JournalEntryModel> createJournalEntry(JournalEntryModel entry) async {
    final db = await database;
    final id = await db.insert(journalEntriesTable, entry.toMap());
    return entry.copyWith(id: id.toString());
  }

  Future<List<JournalEntryModel>> getAllJournalEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      journalEntriesTable,
      orderBy: 'created_at DESC',
    );
    return List.generate(
        maps.length, (i) => JournalEntryModel.fromMap(maps[i]));
  }
}
