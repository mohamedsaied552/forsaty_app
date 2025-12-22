abstract class CommentEvent {}

class AddComment extends CommentEvent {
  final String postId;
  final String userId;
  final String text;

  AddComment({
    required this.postId,
    required this.userId,
    required this.text,
  });
}

class LoadComments extends CommentEvent {
  final String postId;

  LoadComments(this.postId);
}
