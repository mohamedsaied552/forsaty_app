import 'dart:io';
import 'package:forsaty/models/post_model.dart';
import 'package:forsaty/services/post_service.dart';

class PostRepository {
  PostRepository({PostService? service}) : _service = service ?? PostService();

  final PostService _service;

  Future<void> create({
    required PostModel post,
    required List<File> mediaFiles,
  }) async {
    final mediaUrls = await _service.uploadMedia(
      postId: post.id,
      files: mediaFiles,
    );

    final finalPost = PostModel(
      id: post.id,
      userId: post.userId,
      name: post.name,
      title: post.title,
      description: post.description,
      extraTitle: post.extraTitle,
      extraDescription: post.extraDescription,
      mediaUrls: mediaUrls,
      allowRepost: post.allowRepost,
      visibleToAll: post.visibleToAll,
      createdAt: post.createdAt,
    );

    await _service.createPost(finalPost);
  }
}
