import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthResponse {
  const AuthResponse({required this.success, this.message, this.user});

  final bool success;
  final String? message;
  final User? user;
}

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  static final FacebookAuth _facebookAuth = FacebookAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> authStateChanges() => _auth.authStateChanges();

  static Future<bool> isLoggedIn() async => _auth.currentUser != null;

  static Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignore sign-out errors from Google plugin.
    }
    try {
      await _facebookAuth.logOut();
    } catch (_) {
      // Ignore sign-out errors from Facebook plugin.
    }
    await _auth.signOut();
  }

  static Future<AuthResponse> login({
    required String email,
    required String password,
    bool keepMe = true,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResponse(success: true, user: credential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResponse(success: false, message: _messageFromCode(e.code));
    } catch (_) {
      return const AuthResponse(
        success: false,
        message: 'Unexpected error. Please try again.',
      );
    }
  }

  static Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null && name.isNotEmpty) {
        await user.updateDisplayName(name);
      }
      return AuthResponse(success: true, user: user);
    } on FirebaseAuthException catch (e) {
      return AuthResponse(success: false, message: _messageFromCode(e.code));
    } catch (_) {
      return const AuthResponse(
        success: false,
        message: 'Unexpected error. Please try again.',
      );
    }
  }

  static Future<AuthResponse> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final userCredential = await _auth.signInWithPopup(
          GoogleAuthProvider(),
        );
        return AuthResponse(success: true, user: userCredential.user);
      }

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const AuthResponse(
          success: false,
          message: 'Google sign-in was cancelled.',
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return AuthResponse(success: true, user: userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AuthResponse(success: false, message: _messageFromCode(e.code));
    } catch (_) {
      return const AuthResponse(
        success: false,
        message: 'Google sign-in failed. Please try again.',
      );
    }
  }

  static Future<AuthResponse> signInWithFacebook() async {
    try {
      final result = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      switch (result.status) {
        case LoginStatus.success:
          final accessToken = result.accessToken;
          if (accessToken == null) {
            return const AuthResponse(
              success: false,
              message: 'Facebook access token missing.',
            );
          }
          final credential = FacebookAuthProvider.credential(accessToken.token);
          final userCredential = await _auth.signInWithCredential(credential);
          return AuthResponse(success: true, user: userCredential.user);
        case LoginStatus.cancelled:
          return const AuthResponse(
            success: false,
            message: 'Facebook sign-in was cancelled.',
          );
        case LoginStatus.failed:
        case LoginStatus.operationInProgress:
          return AuthResponse(
            success: false,
            message: result.message ?? 'Facebook sign-in failed.',
          );
      }
    } on FirebaseAuthException catch (e) {
      return AuthResponse(success: false, message: _messageFromCode(e.code));
    } catch (_) {
      return const AuthResponse(
        success: false,
        message: 'Facebook sign-in failed. Please try again.',
      );
    }
  }

  static Future<AuthResponse> signInWithApple() async {
    return const AuthResponse(
      success: false,
      message: 'Apple sign-in not configured yet.',
    );
  }

  static String _messageFromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No user found with these credentials.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email is already registered.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'operation-not-allowed':
        return 'This sign-in method is disabled.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method for that email.';
      case 'invalid-credential':
        return 'The supplied credential is malformed or has expired.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return 'Authentication failed. ($code)';
    }
  }
}
