import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final CollectionReference _usersRef =
  FirebaseFirestore.instance.collection('users');


  Future<void> createUserProfile(User user) async {
    try {
      await _usersRef.doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Could not create user profile - $e');
    }
  }

  Future<User?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _usersRef.doc(uid).get();
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      throw Exception('Could not fetch user - $e');
    }
  }

  Future<void> updatePersonalInfo({
    required String uid,
    String? name,
    String? phone,
    String? bio
  }) async {
    Map<String, dynamic> updates = {};
    if (name != null) updates['name'] = name;
    if (phone != null) updates['phone'] = phone;
    if (bio != null) updates['bio'] = bio;

    if (updates.isNotEmpty) {
      await _usersRef.doc(uid).update(updates);
    }
  }

  Future<void> updateWorkerSkills(String uid, List<String> newSkills) async {
    await _usersRef.doc(uid).update({
      'skills': newSkills,
    });
  }

  Future<void> adminUpdateUser(String targetUid, Map<String, dynamic> rawUpdates) async {
    await _usersRef.doc(targetUid).update(rawUpdates);
  }

  Future<List<User>> getAllUsers() async {
    QuerySnapshot snapshot = await _usersRef.get();
    return snapshot.docs
        .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}