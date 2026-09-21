import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quittr/core/bloc_observer.dart';
import 'package:quittr/core/injection_container.dart' as di;
import 'package:quittr/core/presentation/theme/theme.dart';
import 'package:quittr/core/routing/app_router.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:quittr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quittr/features/breathing_exercise/presentation/bloc/breathing_bloc.dart';
import 'package:quittr/features/craving%20control/presentation/bloc/craving_controll_bloc.dart';
import 'package:quittr/features/home/presentation/bloc/home_bloc.dart';
import 'package:quittr/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:quittr/features/pledge/presentation/bloc/notification_bloc.dart';
import 'package:quittr/features/reason/presentation/bloc/reason_bloc.dart';
import 'package:quittr/features/relapse_tracker/presentation/bloc/relapse_tracker_bloc.dart';
import 'package:quittr/firebase_options.dart';
import 'package:quittr/core/presentation/theme/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure URL strategy for web (path-based URLs without hash)
  // if (kIsWeb) {
  //   setUrlStrategy(PathUrlStrategy());
  // }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init();
  await di.init();
  Bloc.observer = AppBlocObserver();

  runApp(const QuittrApp());
}

class QuittrApp extends StatelessWidget {
  const QuittrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository: di.sl())),
        BlocProvider(create: (_) => ThemeCubit(settingsRepository: di.sl())),
        BlocProvider(create: (_) => RelapseTrackerBloc()),
        BlocProvider(create: (_) => BreathingBloc()),
        BlocProvider(create: (_) => CravingControllBloc()),
        BlocProvider(create: (_) => di.sl<JournalBloc>()),
        BlocProvider<ReasonBloc>(create: (context) => di.sl<ReasonBloc>()),
        BlocProvider(create: (_) => NotificationBloc(di.sl(), di.sl())),
        BlocProvider<AchievementsBloc>(
          create: (context) => di.sl<AchievementsBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => di.sl<HomeBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          final theme = MaterialTheme(GoogleFonts.poppinsTextTheme());
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            title: 'NoTempt',
            debugShowCheckedModeBanner: false,
            theme: theme.light(),
            darkTheme: theme.dark(),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
