import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/pledge/data/data%20sources/local_notification_datasource.dart';
import 'package:quittr/features/pledge/domain/repository/local_notification_repository.dart';

class LocalNotificationRepositoryImpl implements LocalNotificationRepository {
  final LocalNotificationDataSourceImpl dataSource;

  LocalNotificationRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> scheduleNotification({
    required String title,
    required String body,
    required Duration delay,
  }) async {
    try {
      final result = await dataSource.scheduleNotification(
        title: title,
        body: body,
        delay: delay,
      );
      return Right(result);
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
