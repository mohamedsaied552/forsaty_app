import '../models/job_model.dart';
import '../models/post_model.dart';
import '../services/home_service.dart';

class HomeRepository {
  HomeRepository({HomeService? service}) : _service = service ?? HomeService();

  final HomeService _service;

  Future<List<JobModel>> jobs({required String category}) => _service.fetchJobs(category: category);

  Future<List<PostModel>> posts({required String category}) => _service.fetchPosts(category: category);
}
