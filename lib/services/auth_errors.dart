import 'package:firebase_auth/firebase_auth.dart';

class AuthExceptionHandler {
  static String handleException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'The email address is already in use by another account.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled.';
        case 'weak-password':
          return 'The password is too weak. Please use a stronger password.';
        case 'user-disabled':
          return 'This user account has been disabled by an administrator.';
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-credential':
          return 'Invalid credentials. Please check your info.';
        case 'too-many-requests':
          return 'Too many requests. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'user-token-expired':
          return 'Your session has expired. Please sign in again.';
        case 'requires-recent-login':
          return 'This operation requires recent authentication. Please sign in again.';
        default:
          return 'An error occurred: ${e.message ?? e.code}';
      }
    } else {
      return 'An error occurred: ${e.toString()}';
    }
  }
}