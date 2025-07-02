import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/user_repository_impl.dart';

// Events
abstract class UserEvent {}
class LoadUsers extends UserEvent {}
class AddUser extends UserEvent {
  final User user;
  AddUser(this.user);
}
class UpdateUser extends UserEvent {
  final int id;
  final User user;
  UpdateUser(this.id, this.user);
}
class DeleteUser extends UserEvent {
  final int id;
  DeleteUser(this.id);
}

// States
abstract class UserState {}
class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final List<User> users;
  UserLoaded(this.users);
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepositoryImpl repository;
  UserBloc(this.repository) : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await repository.getAll();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<AddUser>((event, emit) async {
      try {
        await repository.create(event.user);
        add(LoadUsers());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<UpdateUser>((event, emit) async {
      try {
        await repository.update(event.id, event.user);
        add(LoadUsers());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<DeleteUser>((event, emit) async {
      try {
        await repository.delete(event.id);
        add(LoadUsers());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
} 