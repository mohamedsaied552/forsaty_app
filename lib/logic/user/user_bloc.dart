import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../repositories/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUserInfo>(_onUpdateUserInfo);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await repository.getUser(event.uid);
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserError("User not found"));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUserInfo(UpdateUserInfo event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await repository.updateUserInfo(uid: event.uid, name: event.name, phone: event.phone, bio: event.bio);
      emit(UserUpdated());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
