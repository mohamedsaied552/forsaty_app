import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create post
  Future<void> createPost(String content) async {
    await _firestore.collection('posts').add({
      'content': content,
      'createdAt': Timestamp.now(),
      'likesCount': 0,
    });
  }

  /// Get posts stream
  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Like post
  Future<void> likePost(String postId) async {
    final postRef = _firestore.collection('posts').doc(postId);
    await postRef.update({
      'likesCount': FieldValue.increment(1),
    });
  }

  /// Add comment
  Future<void> addComment(String postId, String text) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'postId': postId,
      'text': text,
      'createdAt': Timestamp.now(),
    });
  }

  /// Get comments
  Stream<List<CommentModel>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CommentModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}
