import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_dto.dart';
import '../../domain/repositories/user_repository.dart';

abstract class UserState {}
class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final List<UserDto> users;
  UserLoaded(this.users);
}
class UserDetailLoaded extends UserState {
  final UserDto? user;
  UserDetailLoaded(this.user);
}
class UserError extends UserState {
  final String error;
  UserError(this.error);
}

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;
  UserCubit(this.repository) : super(UserInitial());

  Future<void> getAll() async {
    emit(UserLoading());
    try {
      final list = await repository.getAll();
      emit(UserLoaded(list));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> getById(int id) async {
    emit(UserLoading());
    try {
      final user = await repository.getById(id);
      emit(UserDetailLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> update(int id, UserDto dto, String token) async {
    emit(UserLoading());
    try {
      await repository.update(id, dto, token);
      emit(UserInitial());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
} 