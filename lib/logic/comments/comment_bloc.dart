import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_event.dart';
import 'comment_state.dart';
import '../../repositories/comment_repository.dart';
import '../../models/comment_model.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository repository;

  CommentBloc(this.repository) : super(CommentInitial()) {
    on<AddComment>(_onAddComment);
    on<LoadComments>(_onLoadComments);
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentState> emit,
  ) async {
    try {
      final comment = Comment(
        id: '',
        postId: event.postId,
        userId: event.userId,
        text: event.text,
        createdAt: DateTime.now(),
      );

      await repository.addComment(comment);
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());

    try {
      repository.getComments(event.postId).listen((comments) {
        emit(CommentLoaded(comments));
      });
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
