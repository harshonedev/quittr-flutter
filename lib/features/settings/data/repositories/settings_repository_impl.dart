import 'package:dartz/dartz.dart';
import 'package:rxdart/subjects.dart';
import 'package:quittr/core/database/database_helper.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/settings/domain/entities/app_settings.dart';
import 'package:quittr/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final DatabaseHelper _dbHelper;
  final _settingsController = BehaviorSubject<AppSettings>();

  SettingsRepositoryImpl(this._dbHelper) {
    // Initialize with default settings
    _initSettings();
  }

  Future<void> _initSettings() async {
    final settings = await getSettings();
    settings.fold(
      (failure) => null,
      (settings) => _settingsController.add(settings),
    );
  }

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.settingsTable,
        limit: 1,
      );

      if (maps.isEmpty) {
        // Create default settings if none exist
        final defaultSettings = const AppSettings();
        final id = await db.insert(
          DatabaseHelper.settingsTable,
          defaultSettings.toMap(),
        );
        return Right(AppSettings(id: id));
      }

      return Right(AppSettings.fromMap(maps.first));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSettings(AppSettings settings) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        DatabaseHelper.settingsTable,
        settings.toMap(),
        where: 'id = ?',
        whereArgs: [settings.id],
      );
      _settingsController.add(settings);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Stream<AppSettings> get settingsStream => _settingsController.stream;

  void dispose() {
    _settingsController.close();
  }
}
