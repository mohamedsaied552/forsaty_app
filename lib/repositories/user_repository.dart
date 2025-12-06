import '../services/user_service.dart';
import '../models/user.dart';

class UserRepository {
  final UserService _userService;

  UserRepository(this._userService);

  Future<User?> getUser(String uid) => _userService.getUser(uid);
  Future<void> createUser(User user) => _userService.createUserProfile(user);
  Future<void> updateUserInfo({
    required String uid,
    String? name,
    String? phone,
    String? bio,
  }) => _userService.updatePersonalInfo(
    uid: uid,
    name: name,
    phone: phone,
    bio: bio,
  );
  Future<void> updateWorkerSkills(String uid, List<String> skills) =>
      _userService.updateWorkerSkills(uid, skills);
  Future<List<User>> getAllUsers() => _userService.getAllUsers();
}
