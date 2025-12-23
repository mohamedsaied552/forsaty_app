import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_model.dart';
import '../models/post_model.dart';

class HomeService {
  HomeService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<JobModel>> fetchJobs({String category = 'All'}) async {
    Query query = _firestore.collection('jobs').orderBy('createdAt', descending: true);

    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    final snap = await query.limit(20).get();
    return snap.docs.map((d) => JobModel.fromDoc(d)).toList();
  }

  Future<List<PostModel>> fetchPosts({String category = 'All'}) async {
    Query query = _firestore.collection('posts').orderBy('createdAt', descending: true);

    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    final snap = await query.limit(20).get();
    return snap.docs.map((d) => PostModel.fromDoc(d)).toList();
  }
}
