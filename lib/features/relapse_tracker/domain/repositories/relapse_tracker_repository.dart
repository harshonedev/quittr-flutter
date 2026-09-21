import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/relapse_tracker/domain/entities/relapse_entry.dart';
import 'package:quittr/features/relapse_tracker/domain/entities/statistics.dart';
import 'package:quittr/features/relapse_tracker/domain/entities/streak.dart';

abstract class RelapseTrackerRepository {
  Either<Failure, Stream<Streak>> getCurrentStreak(String userId);
  Future<Either<Failure, void>> logRelapse(RelapseEntry entry);
  Future<Either<Failure, void>> startNewStreak(String userId);
  Future<Either<Failure, List<Streak>>> getAllStreaks(String userId);
  Future<Either<Failure, List<RelapseEntry>>> getRelapseEntries(String userId);
  Future<Either<Failure, Statistics>> getStatistics(String userId);
}
