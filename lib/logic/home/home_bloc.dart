import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({HomeRepository? repository})
    : _repo = repository ?? HomeRepository(),
      super(HomeState.initial()) {
    on<HomeStarted>(_onStarted);
    on<HomeCategoryChanged>(_onCategoryChanged);
  }

  final HomeRepository _repo;

  Future<void> _load(Emitter<HomeState> emit, String category) async {
    emit(
      state.copyWith(
        status: HomeStatus.loading,
        category: category,
        error: null,
      ),
    );
    try {
      final jobs = await _repo.jobs(category: category);
      final posts = await _repo.posts(category: category);
      emit(
        state.copyWith(status: HomeStatus.success, jobs: jobs, posts: posts),
      );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    await _load(emit, state.category);
  }

  Future<void> _onCategoryChanged(
    HomeCategoryChanged event,
    Emitter<HomeState> emit,
  ) async {
    await _load(emit, event.category);
  }
}
