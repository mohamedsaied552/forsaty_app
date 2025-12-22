class PostModel {
  final String id;
  final String content;
  final DateTime createdAt;
  final int likesCount;

  PostModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.likesCount,
  });

  factory PostModel.fromMap(String id, Map<String, dynamic> data) {
    return PostModel(
      id: id,
      content: data['content'] ?? '',
      createdAt: (data['createdAt']).toDate(),
      likesCount: data['likesCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'createdAt': createdAt,
      'likesCount': likesCount,
    };
  }
}
