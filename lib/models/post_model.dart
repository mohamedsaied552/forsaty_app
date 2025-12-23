import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String name;
  final String title;
  final String description;
  final String? extraTitle;
  final String? extraDescription;
  final List<String> mediaUrls;
  final bool allowRepost;
  final bool visibleToAll;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.title,
    required this.description,
    required this.mediaUrls,
    required this.allowRepost,
    required this.visibleToAll,
    required this.createdAt,
    this.extraTitle,
    this.extraDescription,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'name': name,
    'title': title,
    'description': description,
    'extraTitle': extraTitle,
    'extraDescription': extraDescription,
    'mediaUrls': mediaUrls,
    'allowRepost': allowRepost,
    'visibleToAll': visibleToAll,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory PostModel.fromDoc(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return PostModel(
      id: (data['id'] ?? doc.id) as String,
      userId: (data['userId'] ?? '') as String,
      name: (data['name'] ?? '') as String,
      title: (data['title'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      extraTitle: data['extraTitle'] as String?,
      extraDescription: data['extraDescription'] as String?,
      mediaUrls: List<String>.from(data['mediaUrls'] ?? const []),
      allowRepost: (data['allowRepost'] ?? true) as bool,
      visibleToAll: (data['visibleToAll'] ?? true) as bool,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  String get body => description;
}
