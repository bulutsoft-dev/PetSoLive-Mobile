import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/admin.dart';
import '../../data/repositories/admin_repository_impl.dart';

// Events
abstract class AdminEvent {}
class LoadAdmins extends AdminEvent {}
class AddAdmin extends AdminEvent {
  final Admin admin;
  AddAdmin(this.admin);
}
class UpdateAdmin extends AdminEvent {
  final int id;
  final Admin admin;
  UpdateAdmin(this.id, this.admin);
}
class DeleteAdmin extends AdminEvent {
  final int id;
  DeleteAdmin(this.id);
}

// States
abstract class AdminState {}
class AdminInitial extends AdminState {}
class AdminLoading extends AdminState {}
class AdminLoaded extends AdminState {
  final List<Admin> admins;
  AdminLoaded(this.admins);
}
class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}

// Bloc
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepositoryImpl repository;
  AdminBloc(this.repository) : super(AdminInitial()) {
    on<LoadAdmins>((event, emit) async {
      emit(AdminLoading());
      try {
        final admins = await repository.getAll();
        emit(AdminLoaded(admins));
      } catch (e) {
        emit(AdminError(e.toString()));
      }
    });
    on<AddAdmin>((event, emit) async {
      try {
        await repository.create(event.admin);
        add(LoadAdmins());
      } catch (e) {
        emit(AdminError(e.toString()));
      }
    });
    on<UpdateAdmin>((event, emit) async {
      try {
        await repository.update(event.id, event.admin);
        add(LoadAdmins());
      } catch (e) {
        emit(AdminError(e.toString()));
      }
    });
    on<DeleteAdmin>((event, emit) async {
      try {
        await repository.delete(event.id);
        add(LoadAdmins());
      } catch (e) {
        emit(AdminError(e.toString()));
      }
    });
  }
} 