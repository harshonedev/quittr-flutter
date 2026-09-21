import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quittr/core/routing/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/social_auth_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthLoggedIn) {
              // User has successfully logged in
              _onLoggedIn(context, state);
            } else if (state is AuthError) {
              // Handle authentication error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          }),
        ],
        child: _AuthScreenContent(
          onGoogleSignIn: () => _onGoogleSignInPressed(context),
          onAppleSignIn: () => _onAppleSignInPressed(context),
          onEmailSignIn: () => context.go('/auth/email'),
        ),
      ),
    );
  }

  void _onLoggedIn(BuildContext context, AuthLoggedIn authState) {
    // If user is new, show quiz questions screen, else show home screen.
    AppRouter.isAuthenticated = true;
    if (authState.user.isNewUser) {
      _startQuiz(context);
    } else {
      context.go('/home');
    }
  }

  void _onGoogleSignInPressed(BuildContext context) {
    context.read<AuthBloc>().add(SignInWithGoogle());
  }

  void _onAppleSignInPressed(BuildContext context) {
    context.read<AuthBloc>().add(SignInWithApple());
  }

  void _startQuiz(BuildContext context) {
    context.go('/onboard-quiz');
  }
}

// Extracted UI content class to separate UI from logic
class _AuthScreenContent extends StatelessWidget {
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;
  final VoidCallback onEmailSignIn;

  const _AuthScreenContent({
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
    required this.onEmailSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          child: SvgPicture.asset(
            'assets/illustrations/get_started_screen.svg',
            width: MediaQuery.sizeOf(context).width * 1,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withAlpha(12),
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Spacer(),
                        _buildAppLogo(context),
                        const SizedBox(height: 40),
                        _buildWelcomeText(context),
                        const Spacer(),
                        // Platform-specific auth buttons
                        if (kIsWeb || !Platform.isIOS)
                          SocialAuthButton(
                            text: 'Continue with Google',
                            svgAsset: 'assets/illustrations/google_logo.svg',
                            onPressed: onGoogleSignIn,
                            isOutlined: true,
                          ),
                        // if (Theme.of(context).platform == TargetPlatform.iOS)
                        //   SocialAuthButton(
                        //     text: 'Continue with Apple',
                        //     icon: Icons.apple,
                        //     onPressed: onAppleSignIn,
                        //     isOutlined: true,
                        //     backgroundColor: Colors.black,
                        //     textColor: Colors.white,
                        //     iconColor: Colors.white,
                        //   ),
                        const SizedBox(height: 16),
                        SocialAuthButton(
                          text: 'Sign in with Email',
                          icon: Icons.email_outlined,
                          onPressed: onEmailSignIn,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppLogo(BuildContext context) {
    return Hero(
      tag: 'app_logo',
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withAlpha(76),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Icon(
          Icons.healing_rounded,
          size: 48,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome to NoTempt',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Start your journey to a healthier life',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
