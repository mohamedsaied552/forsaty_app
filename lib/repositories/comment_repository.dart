import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';

class CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(Comment comment) async {
    await _firestore
        .collection('posts')
        .doc(comment.postId)
        .collection('comments')
        .add(comment.toMap());
  }

  Stream<List<Comment>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Comment.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}
