import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
  @override
  List<Object?> get props => [];
}

class PostTitleChanged extends PostEvent {
  final String value;
  const PostTitleChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class PostDescriptionChanged extends PostEvent {
  final String value;
  const PostDescriptionChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class PostExtraTitleChanged extends PostEvent {
  final String value;
  const PostExtraTitleChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class PostExtraDescriptionChanged extends PostEvent {
  final String value;
  const PostExtraDescriptionChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class PostAllowRepostToggled extends PostEvent {
  final bool value;
  const PostAllowRepostToggled(this.value);
  @override
  List<Object?> get props => [value];
}

class PostVisibleToAllToggled extends PostEvent {
  final bool value;
  const PostVisibleToAllToggled(this.value);
  @override
  List<Object?> get props => [value];
}

class PostMediaAdded extends PostEvent {
  final List<File> files;
  const PostMediaAdded(this.files);
  @override
  List<Object?> get props => [files];
}

class PostMediaRemoved extends PostEvent {
  final int index;
  const PostMediaRemoved(this.index);
  @override
  List<Object?> get props => [index];
}

class PostSubmitted extends PostEvent {
  final String userId;
  final String name;

  const PostSubmitted({required this.userId, required this.name});

  @override
  List<Object?> get props => [userId, name];
}
