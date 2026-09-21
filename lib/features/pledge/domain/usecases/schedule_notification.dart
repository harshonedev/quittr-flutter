// import 'dart:async';

// import 'package:dartz/dartz.dart';
// import 'package:quittr/core/error/failures.dart';
// import 'package:quittr/core/usecases/usecase.dart';
// import 'package:quittr/features/pledge/domain/repository/local_notification_repository.dart';

// class ScheduleNotification extends UseCase<void , NoParams> {
//    final LocalNotificationRepository repository;

//   ScheduleNotification(this.repository);
//   @override
//   FutureOr<Either<Failure, void>> call(NoParams params) async{

//     return await repository.scheduleNotification();
  
//   }
// }



import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/pledge/domain/repository/local_notification_repository.dart';

class ScheduleNotification extends UseCase<void, NotificationParams> {
  final LocalNotificationRepository repository;

  ScheduleNotification(this.repository);

  @override
  FutureOr<Either<Failure, void>> call(NotificationParams params) async {
    return await repository.scheduleNotification(
      title: params.title,
      body: params.body,
      delay: params.delay,
    );
  }
}

class NotificationParams {
  final String title;
  final String body;
  final Duration delay;

  NotificationParams({required this.title, required this.body, required this.delay});
}
