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

  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user == null) throw Exception("User creation failed");

      UserModel newUser = UserModel(
        id: user.uid,
        email: email,
        role: role,
        name: name,
        phone: phone,
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

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}