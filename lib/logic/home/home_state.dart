import 'package:equatable/equatable.dart';
import '../../models/job_model.dart';
import '../../models/post_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final String category;
  final List<JobModel> jobs;
  final List<PostModel> posts;
  final String? error;

  const HomeState({
    required this.status,
    required this.category,
    required this.jobs,
    required this.posts,
    required this.error,
  });

  factory HomeState.initial() => const HomeState(
    status: HomeStatus.initial,
    category: 'All',
    jobs: [],
    posts: [],
    error: null,
  );

  HomeState copyWith({
    HomeStatus? status,
    String? category,
    List<JobModel>? jobs,
    List<PostModel>? posts,
    String? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      category: category ?? this.category,
      jobs: jobs ?? this.jobs,
      posts: posts ?? this.posts,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, category, jobs, posts, error];
}
