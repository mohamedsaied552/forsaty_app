class Comment {
  final String id;
  final String postId;
  final String userId;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromMap(String id, Map<String, dynamic> map) {
    return Comment(
      id: id,
      postId: map['postId'],
      userId: map['userId'],
      text: map['text'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
