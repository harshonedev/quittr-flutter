import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quittr/features/achievements/presentation/bloc/achievements_bloc.dart';
import 'package:quittr/features/achievements/presentation/screens/achievements_screen.dart';
import 'package:quittr/features/auth/presentation/screens/auth_screen.dart';
import 'package:quittr/features/home/presentation/screens/home_screen.dart';
import 'package:quittr/features/journal/domain/entities/journal_entry.dart';
import 'package:quittr/features/journal/presentation/screens/journal_detail_screen.dart';
import 'package:quittr/features/onboarding/presentation/screens/get_started_screen.dart';
import 'package:quittr/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:quittr/features/paywall/presentation/screens/paywall_screen.dart';
import 'package:quittr/features/paywall/presentation/screens/subscription_management_screen.dart';
import 'package:quittr/features/reason/data/models/reason_model.dart';
import 'package:quittr/features/reason/presentation/screens/reason_detail_screen.dart';
import 'package:quittr/features/settings/presentation/screens/settings_screen.dart';
import 'package:quittr/core/presentation/screens/splash_screen.dart';
import 'package:quittr/core/presentation/screens/terms_of_service_screen.dart';
import 'package:quittr/core/presentation/screens/privacy_policy_screen.dart';
import 'package:quittr/features/paywall/presentation/screens/susbcricption_status_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/injection_container.dart';
import 'package:quittr/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quittr/features/paywall/domain/usecases/check_subscription_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quittr/features/auth/presentation/screens/email_auth_screen.dart';
import 'package:quittr/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:quittr/features/breathing_exercise/presentation/screens/breathing_excercise_page.dart';
import 'package:quittr/features/craving%20control/presentation/screens/craving_controll.dart';
import 'package:quittr/features/detox/presentation/screens/detox_screen.dart';
import 'package:quittr/features/journal/presentation/screens/journal_screen.dart';
import 'package:quittr/features/library/domain/entities/article.dart';
import 'package:quittr/features/library/presentation/screens/article_detail_screen.dart';
import 'package:quittr/features/library/presentation/screens/articles_screen.dart';
import 'package:quittr/features/library/presentation/screens/learn_screen.dart';
import 'package:quittr/features/library/presentation/screens/podcast_screen.dart';
import 'package:quittr/features/meditate/presentation/screens/meditate_screen.dart';
import 'package:quittr/features/motivaton/presentation/screens/motivation_screen.dart';
import 'package:quittr/features/onboarding/presentation/bloc/quiz_bloc.dart';
import 'package:quittr/features/onboarding/presentation/screens/choose_goals_screen.dart';
import 'package:quittr/features/onboarding/presentation/screens/testimonials_screen.dart';
import 'package:quittr/features/onboarding/presentation/screens/quiz/calculating_quiz_result_screen.dart';
import 'package:quittr/features/onboarding/presentation/screens/quiz/quiz_name_age_screen.dart';
import 'package:quittr/features/onboarding/presentation/screens/quiz/quiz_questions_screen.dart';
import 'package:quittr/features/onboarding/presentation/screens/quiz/quiz_result_screen.dart';
import 'package:quittr/features/onboarding/presentation/screens/quiz/check_symptoms_screen.dart';
import 'package:quittr/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:quittr/features/profile/presentation/screens/profile_screen.dart';
import 'package:quittr/features/reason/presentation/screens/reason_list_screen.dart';
import 'package:quittr/features/side%20effects/presentaion/screens/side_effects_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static bool isAuthenticated = false;
  static bool isGoogleTestUser = false;
  static bool isSubscribed = false;

  // Static method to check if user has active subscription
  static Future<bool> isUserSubscribed() async {
    if (!isAuthenticated) return false;

    try {
      final checkSubscriptionUseCase = sl<CheckSubscriptionStatusUseCase>();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return false;

      final result = await checkSubscriptionUseCase(currentUser.uid);
      return result.fold(
        (failure) => false,
        (subscribedProduct) => subscribedProduct != null,
      );
    } catch (e) {
      return false;
    }
  }

  static final GoRouter router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      debugLogDiagnostics: true,
      routes: [
        // Initial route with splash screen
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),

        // Get Started Route
        GoRoute(
          path: '/get-started',
          builder: (context, state) => const GetStartedScreen(),
        ),

        // Auth Routes
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthScreen(),
          routes: [
            GoRoute(
              path: 'email',
              builder: (context, state) => const EmailAuthScreen(),
            ),
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) => const ForgotPasswordScreen(),
            ),
          ],
        ),

        // Main App Shell Route with Bottom Navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) =>
              ScaffoldWithBottomNav(child: child),
          routes: [
            // Home Route
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),

            // Profile Routes
            GoRoute(
              path: '/profile/edit',
              builder: (context, state) => const EditProfileScreen(),
            ),

            // Recovery Tools Routes
            GoRoute(
              path: '/breathing',
              builder: (context, state) => const BreathingExcercisePage(),
            ),
            GoRoute(
              path: '/meditation',
              builder: (context, state) => const MeditateScreen(),
            ),
            GoRoute(
              path: '/craving-control',
              builder: (context, state) => const CravingControll(),
            ),
            GoRoute(
              path: '/detox',
              builder: (context, state) => const DetoxScreen(),
            ),

            // Progress Routes
            GoRoute(
              path: '/journal',
              builder: (context, state) => const JournalScreen(),
            ),
            GoRoute(
              path: '/reasons',
              builder: (context, state) => const ReasonListScreen(),
            ),

            // Settings & Support Routes
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: '/side-effects',
              builder: (context, state) => const SideEffectsScreen(),
            ),
            GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen()),
          ],
        ),

        // Onboarding Routes
        GoRoute(
          path: '/onboarding',
          builder: (context, state) {
            final userInfo = state.extra as Map<dynamic, dynamic>;
            return OnboardingScreen(userInfo: userInfo);
          },
          routes: [
            GoRoute(
              path: 'goals',
              builder: (context, state) {
                final userInfo = state.extra as Map<dynamic, dynamic>;
                return ChooseGoalsScreen(userInfo: userInfo);
              },
            ),
            GoRoute(
              path: 'testimonials',
              builder: (context, state) {
                final userInfo = state.extra as Map<dynamic, dynamic>;
                return TestimonialsScreen(userInfo: userInfo);
              },
            ),
          ],
        ),

        GoRoute(
            path: '/onboard-quiz',
            builder: (context, state) {
              return BlocProvider<QuizBloc>(
                create: (context) => sl<QuizBloc>()..add(LoadQuizQuestions()),
                child: const QuizQuestionsScreen(),
              );
            },
            routes: [
              GoRoute(
                path: 'quiz-name-age',
                builder: (context, state) {
                  final quizAnswers = state.extra as Map<dynamic, dynamic>;
                  return QuizNameAgeScreen(quizAnswers: quizAnswers);
                },
              ),
              GoRoute(
                path: 'calculating-quiz-result',
                builder: (context, state) {
                  final userInfo = state.extra as Map<dynamic, dynamic>;
                  return CalculatingQuizResultScreen(userInfo: userInfo);
                },
              ),
              GoRoute(
                path: 'quiz-result',
                builder: (context, state) {
                  final userInfo = state.extra as Map<dynamic, dynamic>;
                  return QuizResultScreen(userInfo: userInfo);
                },
              ),
              GoRoute(
                path: 'check-symptoms',
                builder: (context, state) {
                  final userInfo = state.extra as Map<dynamic, dynamic>;
                  return CheckSymptomsScreen(userInfo: userInfo);
                },
              ),
            ]),

        // Paywall Route (Modal)
        GoRoute(
          path: '/paywall',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            return const PaywallScreen();
          },
        ),

        // Terms of Service Route
        GoRoute(
          path: '/terms',
          builder: (context, state) => const TermsOfServiceScreen(),
        ),

        // Privacy Policy Route
        GoRoute(
          path: '/privacy-policy',
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),

        // Route for callaback from polar when paymnent is completed
        GoRoute(
            path: '/subscription-status',
            builder: (context, state) {
              final checkoutId = state.uri.queryParameters['checkout_id'];
              print('Checkout ID: $checkoutId');
              return SusbcricptionStatusScreen();
            }),

        GoRoute(
            path: '/subscription-success-monthly',
            builder: (context, state) {
              return SusbcricptionStatusScreen(
                subscriptionPlanType: SubscriptionPlanType.monthly,
              );
            }),

        GoRoute(
            path: '/subscription-success-yearly',
            builder: (context, state) {
              return const SusbcricptionStatusScreen(
                subscriptionPlanType: SubscriptionPlanType.yearly,
              );
            }),

        GoRoute(
          path: '/articles',
          builder: (context, state) => ArticlesScreen(),
        ),

        GoRoute(
          path: '/articles/detail',
          builder: (context, state) {
            final articleMap = state.extra as Map<String, dynamic>;
            return ArticleDetailScreen(
              article: Article.fromJson(articleMap),
            );
          },
        ),

        // Motivation Route
        GoRoute(
          path: '/motivation',
          builder: (context, state) => MotivationScreen(),
        ),

        // Learn Route
        GoRoute(
          path: '/learn',
          builder: (context, state) => const LearnScreen(),
        ),

        // Podcast Route
        GoRoute(
          path: '/podcast',
          builder: (context, state) => const PodcastScreen(),
        ),

        // Journal Detail Route
        GoRoute(
          path: '/journal-detail',
          builder: (context, state) {
            final entry = state.extra as JournalEntry;
            return JournalDetailScreen(entry: entry);
          },
        ),

        // Reason Detail Route
        GoRoute(
          path: '/reason-detail',
          builder: (context, state) {
            final reason = state.extra as ReasonModel;
            return ReasonDetailScreen(reason: reason);
          },
        ),

        // Subscription Management Route
        GoRoute(
          path: '/subscription-management',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            return const SubscriptionManagementScreen();
          },
        ),

        // Achievements Route
        GoRoute(
          path: '/achievements',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => BlocProvider(
            create: (context) => sl<AchievementsBloc>(),
            child: const AchievementsScreen(),
          ),
        ),
      ],
      redirect: (context, state) {
        final isAuthRoute = state.matchedLocation.startsWith('/auth');
        final isOnboardingRoute =
            state.matchedLocation.startsWith('/onboarding');
        final isQuizRoute = state.matchedLocation.startsWith('/onboard-quiz');
        final isInitialRoute = state.matchedLocation == '/';
        final isGetStartedRoute = state.matchedLocation == '/get-started';
        final isPaywallRoute = state.matchedLocation.startsWith('/paywall');
        final isTermsRoute = state.matchedLocation.startsWith('/terms') ||
            state.matchedLocation.startsWith('/privacy-policy');
        final isSubscriptionRoute =
            state.matchedLocation.startsWith('/subscription');

        final isProtectedRoute = !isAuthRoute &&
            !isOnboardingRoute &&
            !isQuizRoute &&
            !isInitialRoute &&
            !isGetStartedRoute &&
            !isPaywallRoute &&
            !isTermsRoute &&
            !isSubscriptionRoute;

        final isUserAuthenticated = AuthRepositoryImpl.isUserAuthenticated();

        // If not authenticated and trying to access protected routes
        if (!isUserAuthenticated && isProtectedRoute) {
          return '/auth';
        }

        // If authenticated and trying to access auth routes
        if (isUserAuthenticated && isAuthRoute) {
          print('User is authenticated, redirecting to home from auth route');
          return '/home';
        }
        
        // if authenticated and trying to access initial routes in web
        if (isUserAuthenticated &&
            isInitialRoute &&
            kIsWeb &&
            !state.uri.toString().contains('?initial=true')) {
          print(
              'User is authenticated, redirecting to home from initial route');
          return '/home';
        }

        // Special case for Google test user
        if (isGoogleTestUser && isPaywallRoute) {
          return '/home';
        }

        // If authenticated but not subscribed and trying to access protected routes
        if (isUserAuthenticated &&
            !isSubscribed &&
            isProtectedRoute &&
            !isGoogleTestUser &&
            !kIsWeb) {
          print(
              'User is authenticated but not subscribed, redirecting to paywall');
          return '/paywall';
        }

        return null;
      },
      errorBuilder: (context, state) {
        return Scaffold(
          // show  404 no page found
          body: Center(
            child: Text(
              '404, No Page Found',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        );
      });
}

// Bottom Navigation Scaffold
class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNav({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/journal');
              break;
            case 2:
              context.go('/breathing');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        selectedIndex: _calculateSelectedIndex(context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.book), label: 'Journal'),
          NavigationDestination(icon: Icon(Icons.air), label: 'Breathe'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/journal')) return 1;
    if (location.startsWith('/breathing')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }
}
