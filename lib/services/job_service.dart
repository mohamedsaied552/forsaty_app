import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_model.dart';

class JobService {
  final CollectionReference _jobsRef =
  FirebaseFirestore.instance.collection('jobs');

  /// Create a new Job Post
  Future<void> createJob(JobModel job) async {

    await _jobsRef.add(job.toMap());
  }

  /// Get all Jobs
  Stream<List<JobModel>> getJobsStream() {
    return _jobsRef.orderBy('createdAt', descending: true).snapshots().map((
        snapshot) {
      return snapshot.docs.map((doc) {
        return JobModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Delete a Job
  Future<void> deleteJob(String jobId) async {
    await _jobsRef.doc(jobId).delete();
  }

  /// Update a Job
  Future<void> updateJob(String jobId, Map<String, dynamic> changes) async {
    await _jobsRef.doc(jobId).update(changes);
  }
}