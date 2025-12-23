import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:forsaty/models/post_model.dart';

class PostService {
  PostService({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Future<List<String>> uploadMedia({
    required String postId,
    required List<File> files,
  }) async {
    if (files.isEmpty) return [];

    final urls = <String>[];

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final ref = _storage.ref().child('posts/$postId/media_$i.jpg');

      final uploadTask = await ref.putFile(file);
      final url = await uploadTask.ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  Future<void> createPost(PostModel post) async {
    await _firestore.collection('posts').doc(post.id).set(post.toMap());
  }
}
