import 'dart:math';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/services/logger_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final _logger = LoggerService.instance;

  AuthRepositoryImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  @override
  Stream<User?> get authStateChanges {
    _logger.i('Listening to auth state changes');
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        _logger.i('User signed out');
        return null;
      }
      _logger.i('User signed in: ${firebaseUser.uid}');
      return User(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        name: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
      );
    });
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    int retryCount = 0;

    while (retryCount < 2) {
      // Allow one retry
      try {
        if (kIsWeb) {
          firebase_auth.GoogleAuthProvider googleProvider =
              firebase_auth.GoogleAuthProvider();
          final userCredentials = await firebase_auth.FirebaseAuth.instance
              .signInWithPopup(googleProvider);

          final firebaseUser = _firebaseAuth.currentUser;
          if (firebaseUser == null) {
            _logger.e('Failed to sign in with Google - null user returned');
            return const Left(AuthFailure('Failed to sign in with Google'));
          }
          _logger.i('Google sign in successful for user: ${firebaseUser.uid}');
          return Right(User(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            name: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL,
            isNewUser: userCredentials.additionalUserInfo?.isNewUser ?? false,
          ));
        } else {
          _logger.i('Attempting Google sign in (attempt ${retryCount + 1})');
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
          if (googleUser == null) {
            _logger.w('Google sign in was aborted by user');
            return const Left(AuthFailure('Google sign in aborted'));
          }

          _logger.d('Google account selected: ${googleUser.email}');
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          final credential = firebase_auth.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          _logger.d('Authenticating with Firebase using Google credentials');
          final userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          final firebaseUser = userCredential.user!;
          _logger.i('Google sign in successful for user: ${firebaseUser.uid}');
          return Right(User(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            name: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL,
            isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
          ));
        }
      } catch (e) {
        _logger.e('Google sign-in error (attempt ${retryCount + 1})', error: e);

        if (e is firebase_auth.FirebaseAuthException) {
          if (e.code == 'network-request-failed' && retryCount < 1) {
            // Network error, let's retry once
            _logger.w('Network error detected, retrying...');
            retryCount++;
            await Future.delayed(const Duration(seconds: 2));
            continue;
          }
          return Left(AuthFailure('Google sign-in failed: ${e.message}'));
        }

        // Other errors
        return Left(AuthFailure('Google sign-in error: ${e.toString()}'));
      }
    }

    // This should never happen, but just in case
    _logger.e('Google sign-in failed after maximum retries');
    return const Left(AuthFailure('Google sign-in failed'));
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      _logger.i('Attempting to create user account with email: $email');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user!;

      _logger.i('User account created successfully: ${firebaseUser.uid}');
      return Right(User(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        name: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
      ));
    } on firebase_auth.FirebaseAuthException catch (e) {
      _logger.d('Firebase exception on email/password sign in - ${e.code}');

      if (e.code == 'email-already-in-use') {
        _logger.i('Email already in use, attempting to sign in');
        try {
          final userCredentials =
              await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final firebaseUser = userCredentials.user!;
          _logger.i('User signed in successfully: ${firebaseUser.uid}');
          return Right(
            User(
              id: firebaseUser.uid,
              email: firebaseUser.email,
              name: firebaseUser.displayName,
              isNewUser: false,
            ),
          );
        } on firebase_auth.FirebaseAuthException catch (e) {
          if (e.code == 'invalid-credential') {
            _logger.w('Invalid email or password provided');
            return Left(AuthFailure('Invalid email or password'));
          }
          _logger.e('Sign in failed', error: e);
          return Left(AuthFailure(e.message ?? 'Sign in failed'));
        }
      }
      if (e.code == 'invalid-credential') {
        _logger.w('Invalid email or password provided');
        return Left(AuthFailure('Invalid email or password'));
      }
      _logger.e('Sign in failed', error: e);
      return Left(AuthFailure(e.message ?? 'Sign in failed'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      _logger.i('Sending password reset email to: $email');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      _logger.i('Password reset email sent successfully');
      return const Right(null);
    } catch (e) {
      _logger.e('Failed to send password reset email', error: e);
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      _logger.i('Signing out user');
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _logger.i('Sign out successful');
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      _logger.e('Sign out failed', error: e);
      return Left(AuthFailure(e.message ?? 'Sign out failed'));
    }
  }

  @override
  User? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      _logger.d('No current user found');
      return null;
    }

    _logger.d('Current user: ${firebaseUser.uid}');
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      name: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  @override
  Future<Either<Failure, User>> signInWithApple() async {
    int retryCount = 0;

    while (retryCount < 2) {
      // Allow one retry
      try {
        _logger.i('Attempting Apple sign in (attempt ${retryCount + 1})');
        // Generate nonce
        final rawNonce = _generateNonce();
        final nonce = _sha256ofString(rawNonce);

        _logger.d('Requesting Apple ID credential');
        // Request credential for Apple Sign In
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        _logger.d('Creating OAuth credential for Firebase');
        // Create OAuthCredential
        final oauthCredential =
            firebase_auth.OAuthProvider('apple.com').credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
          accessToken: appleCredential.authorizationCode,
        );

        _logger.d('Signing in to Firebase with Apple credential');
        // Sign in to Firebase
        final userCredential = await _firebaseAuth.signInWithCredential(
          oauthCredential,
        );

        final firebaseUser = userCredential.user;
        if (firebaseUser == null) {
          _logger.e('Failed to sign in with Apple - null user returned');
          return const Left(AuthFailure('Failed to sign in with Apple'));
        }

        // Handle missing name from Apple sign-in
        String? displayName = firebaseUser.displayName;
        if (displayName == null || displayName.isEmpty) {
          if (appleCredential.givenName != null) {
            _logger.d('Adding display name from Apple credential');
            String fullName = [
              appleCredential.givenName,
              appleCredential.familyName,
            ].where((name) => name != null).join(' ');

            if (fullName.isNotEmpty) {
              await firebaseUser.updateDisplayName(fullName);
              displayName = fullName;
            }
          }
        }

        _logger.i('Apple sign in successful for user: ${firebaseUser.uid}');
        // Create User entity
        return Right(User(
          id: firebaseUser.uid,
          email: firebaseUser.email,
          name: displayName,
          photoUrl: firebaseUser.photoURL,
          isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
        ));
      } catch (e) {
        _logger.e('Apple sign-in error (attempt ${retryCount + 1})', error: e);

        if (e is SignInWithAppleAuthorizationException) {
          if (e.code == AuthorizationErrorCode.canceled) {
            _logger.w('Apple sign in canceled by user');
            return const Left(AuthFailure('Apple sign in canceled by user'));
          }
          return Left(AuthFailure('Apple sign-in failed: ${e.message}'));
        }

        if (e is firebase_auth.FirebaseAuthException) {
          if (e.code == 'network-request-failed' && retryCount < 1) {
            // Network error, let's retry once
            _logger.w('Network error detected, retrying...');
            retryCount++;
            await Future.delayed(const Duration(seconds: 2));
            continue;
          }
          return Left(AuthFailure('Apple sign-in failed: ${e.message}'));
        }

        return Left(AuthFailure('Apple sign-in error: ${e.toString()}'));
      }
    }

    // This should never happen, but just in case
    _logger.e('Apple sign-in failed after maximum retries');
    return const Left(AuthFailure('Apple sign-in failed'));
  }

  String _generateNonce([int length = 32]) {
    _logger.d('Generating nonce of length $length');
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    _logger.d('Computing SHA256 hash');
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool isUserAuthenticated() {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      LoggerService.instance.d('No user is currently authenticated');
      return false;
    }
    LoggerService.instance.d('User is authenticated: ${firebaseUser.uid}');
    return true;
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    // delete user acccount
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(AuthFailure("User not logged in "));
      }
      await user.delete();
      return Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return Left(AuthFailure("requires recent login"));
      }

      return Left(AuthFailure("failure occured while delete account"));
    }
  }
}
