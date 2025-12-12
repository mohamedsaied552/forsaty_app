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
        default:
          return 'An undefined error occurred. (${e.code})';
      }
    } else {
      return 'An error occurred: ${e.toString()}';
    }
  }
}