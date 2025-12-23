import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeCategoryChanged extends HomeEvent {
  final String category;
  const HomeCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}
