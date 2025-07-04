import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/admin_repository.dart';

abstract class AdminState {}
class AdminInitial extends AdminState {}
class AdminLoading extends AdminState {}
class AdminLoaded extends AdminState {
  final bool isAdmin;
  AdminLoaded(this.isAdmin);
}
class AdminError extends AdminState {
  final String error;
  AdminError(this.error);
}

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository repository;
  AdminCubit(this.repository) : super(AdminInitial());

  Future<void> checkIsAdmin(int userId) async {
    emit(AdminLoading());
    try {
      final isAdmin = await repository.isUserAdmin(userId);
      emit(AdminLoaded(isAdmin));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
} 