import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateUserEvent extends UserEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  CreateUserEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}

class LoadUser extends UserEvent {
  final String uid;
  LoadUser(this.uid);

  @override
  List<Object?> get props => [uid];
}

class UpdateUserInfo extends UserEvent {
  final String uid;
  final String? name;
  final String? phone;
  final String? bio;

  UpdateUserInfo({required this.uid, this.name, this.phone, this.bio});

  @override
  List<Object?> get props => [uid, name, phone, bio];
}
