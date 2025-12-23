import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forsaty/models/post_model.dart';
import '../../repositories/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({PostRepository? repository})
    : _repository = repository ?? PostRepository(),
      super(PostState.initial()) {
    on<PostTitleChanged>((e, emit) => emit(state.copyWith(title: e.value)));
    on<PostDescriptionChanged>(
      (e, emit) => emit(state.copyWith(description: e.value)),
    );

    on<PostExtraTitleChanged>(
      (e, emit) => emit(state.copyWith(extraTitle: e.value)),
    );
    on<PostExtraDescriptionChanged>(
      (e, emit) => emit(state.copyWith(extraDescription: e.value)),
    );

    on<PostAllowRepostToggled>(
      (e, emit) => emit(state.copyWith(allowRepost: e.value)),
    );
    on<PostVisibleToAllToggled>(
      (e, emit) => emit(state.copyWith(visibleToAll: e.value)),
    );

    on<PostMediaAdded>(_onMediaAdded);
    on<PostMediaRemoved>(_onMediaRemoved);

    on<PostSubmitted>(_onSubmit);
  }

  final PostRepository _repository;

  void _onMediaAdded(PostMediaAdded event, Emitter<PostState> emit) {
    final updated = List<File>.from(state.mediaFiles)..addAll(event.files);
    emit(state.copyWith(mediaFiles: updated));
  }

  void _onMediaRemoved(PostMediaRemoved event, Emitter<PostState> emit) {
    final updated = List<File>.from(state.mediaFiles);
    if (event.index >= 0 && event.index < updated.length) {
      updated.removeAt(event.index);
    }
    emit(state.copyWith(mediaFiles: updated));
  }

  Future<void> _onSubmit(PostSubmitted event, Emitter<PostState> emit) async {
    if (!state.canSubmit) return;

    emit(state.copyWith(status: PostStatus.loading, errorMessage: null));

    try {
      // ✅ REAL unique id from Firestore (NO uuid package needed)
      final postId = FirebaseFirestore.instance.collection('posts').doc().id;

      final post = PostModel(
        id: postId,
        userId: event.userId,
        name: event.name,
        title: state.title.trim(),
        description: state.description.trim(),
        extraTitle: state.extraTitle.trim().isEmpty
            ? null
            : state.extraTitle.trim(),
        extraDescription: state.extraDescription.trim().isEmpty
            ? null
            : state.extraDescription.trim(),
        mediaUrls: const [],
        allowRepost: state.allowRepost,
        visibleToAll: state.visibleToAll,
        createdAt: DateTime.now(),
      );

      await _repository.create(post: post, mediaFiles: state.mediaFiles);

      emit(PostState.initial().copyWith(status: PostStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: PostStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
