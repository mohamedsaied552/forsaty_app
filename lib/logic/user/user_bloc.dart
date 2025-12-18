import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/user_repository.dart';
import '../../models/user_model.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    on<CreateUserEvent>(_onCreateUser);
    on<LoadUser>(_onLoadUser);
    on<UpdateUserInfo>(_onUpdateUserInfo);
  }
  
  Future<void> _onCreateUser(CreateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading()); // حالة انتظار
    
    try {
      // إنشاء مستخدم في Firebase Auth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,       // الإيميل من الحدث
        password: event.password, // الباسورد من الحدث
      );

      final uid = userCredential.user?.uid; // الحصول على uid من Firebase
      if (uid == null) throw Exception("UID is null"); // تحقق من uid

      // إنشاء نموذج المستخدم لحفظه في Firestore
      final user = UserModel(
        id: uid,                  
        name: event.name,     
        email: event.email,       
        password: event.password,  
        role: event.role,      
        phone: '',   
      );

      await repository.createUser(user); // حفظ المستخدم في Firestore

      emit(UserCreated()); // نجاح
    } catch (e) {
      emit(UserError(e.toString())); // فشل مع رسالة الخطأ
    }
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
