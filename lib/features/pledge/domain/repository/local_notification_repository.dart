import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';

abstract class LocalNotificationRepository {
  Future<Either<Failure, void>> scheduleNotification({
    required String title,
    required String body,
    required Duration delay,
  });
}
