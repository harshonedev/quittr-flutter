import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();
  Future<Either<Failure, void>> updateSettings(AppSettings settings);
  Stream<AppSettings> get settingsStream;
}
