import 'dart:io';
import 'package:equatable/equatable.dart';

enum PostStatus { initial, loading, success, failure }

class PostState extends Equatable {
  final PostStatus status;
  final String title;
  final String description;
  final String extraTitle;
  final String extraDescription;
  final bool allowRepost;
  final bool visibleToAll;
  final List<File> mediaFiles;
  final String? errorMessage;

  const PostState({
    this.status = PostStatus.initial,
    this.title = '',
    this.description = '',
    this.extraTitle = '',
    this.extraDescription = '',
    this.allowRepost = true,
    this.visibleToAll = true,
    this.mediaFiles = const [],
    this.errorMessage,
  });

  factory PostState.initial() => const PostState();

  bool get canSubmit =>
      title.trim().isNotEmpty && description.trim().isNotEmpty;

  PostState copyWith({
    PostStatus? status,
    String? title,
    String? description,
    String? extraTitle,
    String? extraDescription,
    bool? allowRepost,
    bool? visibleToAll,
    List<File>? mediaFiles,
    String? errorMessage,
  }) {
    return PostState(
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      extraTitle: extraTitle ?? this.extraTitle,
      extraDescription: extraDescription ?? this.extraDescription,
      allowRepost: allowRepost ?? this.allowRepost,
      visibleToAll: visibleToAll ?? this.visibleToAll,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    title,
    description,
    extraTitle,
    extraDescription,
    allowRepost,
    visibleToAll,
    mediaFiles,
    errorMessage,
  ];
}
