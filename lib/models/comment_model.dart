class CommentModel {
  final String id;
  final String postId;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromMap(String id, Map<String, dynamic> data) {
    return CommentModel(
      id: id,
      postId: data['postId'],
      text: data['text'],
      createdAt: (data['createdAt']).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'text': text,
      'createdAt': createdAt,
    };
  }
}
