import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:quittr/core/presentation/theme/cubit/theme_cubit.dart';
import 'package:quittr/core/services/rating_service.dart';
import 'package:quittr/features/home/presentation/bloc/home_bloc.dart';
import 'package:quittr/features/journal/data/datasources/journal_firestore.dart';
import 'package:quittr/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:quittr/features/library/data/data%20sources/podcast_data_source.dart';
import 'package:quittr/features/library/data/repository/podcast_repository_impl.dart';
import 'package:quittr/features/library/domain/repository/podcast_repository.dart';
import 'package:quittr/features/library/domain/usecases/get_podcasts.dart';
import 'package:quittr/features/library/presentation/bloc/podcast_player_bloc.dart';
import 'package:quittr/features/meditate/data/datasources/meditate_loacal_data_source.dart';
import 'package:quittr/features/meditate/data/repository/quotes_repository_impl.dart';
import 'package:quittr/features/meditate/domain/repository/quotes_repository.dart';
import 'package:quittr/features/meditate/domain/usecases/get_quotes.dart';
import 'package:quittr/features/motivaton/data/data_sources/motivation_quotes_local_datasource.dart';
import 'package:quittr/features/motivaton/data/repository/motivational_quotes_repository_impl.dart';
import 'package:quittr/features/motivaton/domain/repository/motivation_quotes_repository.dart';
import 'package:quittr/features/motivaton/domain/usecases/get_motivationalQuotes.dart';
import 'package:quittr/features/paywall/data/datasources/purchase_data_source.dart';
import 'package:quittr/features/paywall/data/datasources/subscription_firestore.dart';
import 'package:quittr/features/paywall/domain/usecases/check_subscription_status.dart';
import 'package:quittr/features/paywall/domain/usecases/dispose_subscription.dart';
import 'package:quittr/features/paywall/domain/usecases/purchase_by_coupon.dart';
import 'package:quittr/features/paywall/domain/usecases/purchase_web_product.dart';
import 'package:quittr/features/paywall/domain/usecases/restore_purchaces.dart';
import 'package:quittr/features/paywall/domain/usecases/start_listening_updates.dart';
import 'package:quittr/features/paywall/presentation/bloc/paywall_bloc.dart';
import 'package:quittr/features/pledge/data/data%20sources/local_notification_datasource.dart';
import 'package:quittr/features/pledge/data/repository/local_notification_repository_impl.dart';
import 'package:quittr/features/pledge/domain/repository/local_notification_repository.dart';
import 'package:quittr/features/pledge/domain/usecases/schedule_notification.dart';
import 'package:quittr/features/pledge/presentation/bloc/notification_bloc.dart';
import 'package:quittr/features/reason/data/datasources/reason_firestore.dart';
import 'package:quittr/features/reason/data/repositories/reason_repository_impl.dart';
import 'package:quittr/features/reason/domain/repositories/reason_repository.dart';
import 'package:quittr/features/reason/domain/usecases/add_reason.dart';
import 'package:quittr/features/reason/domain/usecases/delete_reason.dart';
import 'package:quittr/features/reason/domain/usecases/get_reasons.dart';
import 'package:quittr/features/reason/presentation/bloc/reason_bloc.dart';
import 'package:quittr/features/side%20effects/data/data_sources/side_effects_local_datasource.dart';
import 'package:quittr/features/side%20effects/data/repository/side_effects_repository_impl.dart';
import 'package:quittr/features/side%20effects/domian/repository/side_effectes_repository.dart';
import 'package:quittr/features/side%20effects/domian/usecases/get_side_effects.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/domain/usecases/update_profile_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quittr/core/services/image_picker_service.dart';
import 'package:quittr/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:quittr/core/database/database_helper.dart';
import 'package:quittr/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:quittr/features/settings/domain/repositories/settings_repository.dart';
import 'package:quittr/features/onboarding/data/datasources/quiz_local_data_source.dart';
import 'package:quittr/features/onboarding/data/repositories/quiz_repository_impl.dart';
import 'package:quittr/features/onboarding/domain/repositories/quiz_repository.dart';
import 'package:quittr/features/onboarding/presentation/bloc/quiz_bloc.dart';
import 'package:quittr/features/journal/domain/usecases/get_journal_entries.dart';
import 'package:quittr/features/journal/domain/usecases/add_journal_entry.dart';
import '../features/journal/data/repositories/journal_repository_impl.dart';
import '../features/journal/domain/repositories/journal_repository.dart';
import '../features/paywall/domain/usecases/initialize_purchases.dart';
import '../features/paywall/domain/usecases/get_subscriptions.dart';
import '../features/paywall/domain/usecases/purchase_product.dart';
import '../features/paywall/data/repositories/purchase_repository_impl.dart';
import '../features/paywall/domain/repositories/purchase_repository.dart';
import '../features/paywall/domain/usecases/get_purchase_updates.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quittr/features/achievements/data/datasources/achievement_data_source.dart';
import 'package:quittr/features/achievements/data/repositories/achievement_repository_impl.dart';
import 'package:quittr/features/achievements/domain/repositories/achievement_repository.dart';
import 'package:quittr/features/achievements/domain/usecases/check_and_update_achievements.dart';
import 'package:quittr/features/achievements/domain/usecases/get_achievements.dart';
import 'package:quittr/features/achievements/domain/usecases/get_total_points.dart';
import 'package:quittr/features/achievements/domain/usecases/unlock_achievement.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:quittr/features/relapse_tracker/presentation/bloc/relapse_tracker_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuth: sl(),
      googleSignIn: sl(),
    ),
  );

  // Features - Profile
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      auth: sl(),
      storage: sl(),
    ),
  );

  // sl.registerLazySingleton(() => GetStorage.init());

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
  sl.registerLazySingleton(() => InAppPurchase.instance);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Logger());

  // Services
  sl.registerLazySingleton<ImagePickerService>(
    () => ImagePickerServiceImpl(picker: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => UpdateProfilePhoto(sl()));

  // Blocs
  sl.registerFactory(() => SettingsBloc(repository: sl()));

  // Database
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  // Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );

  // Cubits
  sl.registerFactory(() => ThemeCubit(settingsRepository: sl()));

  // Quiz Feature
  sl.registerFactory(() => QuizBloc(repository: sl()));
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<QuizLocalDataSource>(
    () => QuizLocalDataSourceImpl(),
  );

  // Journal Feature
  sl.registerLazySingleton(() => GetJournalEntries(sl<JournalRepository>()));
  sl.registerLazySingleton(() => AddJournalEntry(sl<JournalRepository>()));
  // Data Sources
  sl.registerLazySingleton(() => JournalFirestore());
  sl.registerLazySingleton<JournalRepository>(
    () => JournalRepositoryImpl(journalFirestore: sl<JournalFirestore>()),
  );

  // Home Feature
  sl.registerLazySingleton(() => RatingService());
  sl.registerFactory<HomeBloc>(() => HomeBloc(ratingService: sl()));

  // Journal Bloc
  sl.registerFactory<JournalBloc>(() => JournalBloc(
        getJournalEntries: sl<GetJournalEntries>(),
        addJournalEntry: sl<AddJournalEntry>(),
      ));

  // Feature - Reason

  sl.registerLazySingleton<ReasonFirestore>(() => ReasonFirestore());
  sl.registerLazySingleton<ReasonRepository>(
      () => ReasonRepositoryImpl(reasonFirestore: sl()));
  sl.registerLazySingleton(() => AddReason(sl()));
  sl.registerLazySingleton(() => DeleteReason(sl()));
  sl.registerLazySingleton(() => GetReasons(sl()));

  sl.registerFactory<ReasonBloc>(
      () => ReasonBloc(addReason: sl(), getReasons: sl(), deleteReason: sl()));

  // Features - meditation

  sl.registerFactory<MeditateLoacalDataSource>(
      () => MeditateLoacalDataSourceImpl());

  sl.registerFactory<QuotesRepository>(() => QuotesRepositoryImpl(sl()));

  sl.registerFactory(() => GetQuotes(sl()));

  // sl.registerLazySingleton(() => InitializePurchases(sl()));
  // sl.registerLazySingleton(() => GetSubscriptions(sl()));
  // sl.registerLazySingleton(() => PurchaseProduct(sl()));
  // sl.registerLazySingleton(() => GetPurchaseUpdates(sl()));

  // // Repositories
  // sl.registerLazySingleton<PurchaseRepository>(
  //   () => PurchaseRepositoryImpl(dataSource: sl()),
  // );
  // sl.registerLazySingleton<PurchaseDataSource>(
  //   () => PurchaseDataSourceImpl(),
  // );

  //Feature :- Motivation

  sl.registerFactory<MotivationQuotesLocalDatasource>(
      () => MotivationQuotesLocalDatasourceImpl());
  sl.registerFactory<MotivationQuotesRepository>(
      () => MotivationalQuotesRepositoryImpl(sl()));
  sl.registerFactory(() => GetMotivationalquotes(sl()));

  // Features :- Side Effects

  sl.registerFactory<SideEffectsLocalDatasource>(
      () => SideEffectsLocalDatasourceImpl());
  sl.registerFactory<SideEffectesRepository>(
      () => SideEffectsRepositoryImpl(sl()));
  sl.registerFactory(() => GetSideEffects(sl()));

  // Features :- Notification

  sl.registerFactory(() {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return LocalNotificationDataSourceImpl.navigatorKey = navigatorKey;
  });

  sl.registerLazySingleton(() {
    final dataSource = LocalNotificationDataSourceImpl(sl());
    dataSource.initialize(); // Ensures it's initialized
    return dataSource;
  });

  sl.registerFactory<LocalNotificationRepository>(
      () => LocalNotificationRepositoryImpl(sl()));

  sl.registerLazySingleton(() => ScheduleNotification(sl()));

  sl.registerLazySingleton(() => NotificationBloc(sl(), sl()));

  // Features :- Subscription

  sl.registerLazySingleton<SubscriptionDataSource>(
    () => SubscriptionDataSourceImpl(
      logger: sl(),
    ),
  );

  sl.registerLazySingleton<SubscriptionRepository>(() =>
      SubscriptionRepositoryImpl(
          dataSource: sl(), subscriptionFirestore: sl()));

  sl.registerLazySingleton(() => SubscriptionFirestore(firestore: sl()));
  sl.registerLazySingleton(() => PurchaseProductUseCase(sl()));
  sl.registerLazySingleton(() => CheckSubscriptionAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => DisposeSubscriptionUseCase(sl()));
  sl.registerLazySingleton(() => FetchProductsUseCase(sl()));
  sl.registerLazySingleton(() => ListenToPurchaseUpdatesUseCase(sl()));
  sl.registerLazySingleton(() => RestorePurchasesUseCase(sl()));
  sl.registerLazySingleton(
      () => CheckSubscriptionStatusUseCase(repository: sl()));

  sl.registerLazySingleton(() => StartListeningUpdatesUseCase(sl()));
  sl.registerLazySingleton(() => PurchaseWebProduct(sl()));
  sl.registerLazySingleton(() => PurchaseByCoupon(sl()));

  sl.registerLazySingleton(() => SubscriptionBloc(
        purchaseProductUseCase: sl(),
        checkAvailabilityUseCase: sl(),
        disposeSubscriptionUseCase: sl(),
        fetchProductsUseCase: sl(),
        listenToPurchaseUpdatesUseCase: sl(),
        restorePurchasesUseCase: sl(),
        checkSubscriptionStatusUseCase: sl(),
        startListeningUpdatesUseCase: sl(),
        purchaseWebProductUseCase: sl(),
        purchaseByCouponUseCase: sl(),
      ));

  // podcast

  sl.registerLazySingleton<PodcastDataSource>(() => PodcastDataSourceImpl());

  sl.registerLazySingleton<PodcastRepository>(
      () => PodcastRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetPodcasts(podcastRepository: sl()));

  sl.registerLazySingleton(() => PodcastPlayerBloc(getPodcasts: sl()));

  // Features - Achievements
  sl.registerFactory(() => AchievementsBloc(
        getAchievements: sl(),
        unlockAchievement: sl(),
        checkAndUpdateAchievements: sl(),
        getTotalPoints: sl(),
      ));

  sl.registerLazySingleton(() => GetAchievements(sl()));
  sl.registerLazySingleton(() => UnlockAchievement(sl()));
  sl.registerLazySingleton(() => CheckAndUpdateAchievements(sl()));
  sl.registerLazySingleton(() => GetTotalPoints(sl()));

  sl.registerLazySingleton<AchievementRepository>(
    () => AchievementRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<AchievementDataSource>(
    () => AchievementLocalDataSource(storage: GetStorage()),
  );

  // Features - Relapse Tracker
  sl.registerFactory(() => RelapseTrackerBloc());
}
