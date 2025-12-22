import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'user_service.dart';
import 'auth_errors.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();


  Future<String?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role, // 'Worker' or 'Employer'
    String? skills, // Comma-separated skills string for Workers
    String? jobName, // Job name for Employers
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user == null) throw Exception("User creation failed");

      // Parse skills from comma-separated string to list
      List<String> skillsList = [];
      if (skills != null && skills.trim().isNotEmpty) {
        skillsList = skills
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }

      UserModel newUser = UserModel(
        id: user.uid,
        email: email,
        role: role,
        name: name,
        phone: phone,
        skills: skillsList,
        bio: jobName ?? '', // Store jobName in bio field for Employers
      );

      await _userService.createUserProfile(newUser);

      return null; // Success

    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleException(e);
    } catch (e) {
      return "An unknown error occurred: ${e.toString()}";
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleException(e);
    } catch (e) {
      return "Login failed: ${e.toString()}";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String? getCurrentUid() {
    return _auth.currentUser?.uid;
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleException(e);
    } catch (e) {
      return "Failed to send password reset email: ${e.toString()}";
    }
  }

  Future<String?> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      await _auth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleException(e);
    } catch (e) {
      return "Failed to reset password: ${e.toString()}";
    }
  }

  Future<String?> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return "No user is currently signed in.";
      }
      await user.updatePassword(newPassword);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleException(e);
    } catch (e) {
      return "Failed to update password: ${e.toString()}";
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}