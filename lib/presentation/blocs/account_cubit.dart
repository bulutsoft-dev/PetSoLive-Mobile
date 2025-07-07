import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/auth_dto.dart';
import '../../data/models/register_dto.dart';
import '../../data/models/auth_response_dto.dart';
import '../../domain/repositories/account_repository.dart';
import '../../data/local/session_manager.dart';

abstract class AccountState {}
class AccountInitial extends AccountState {}
class AccountLoading extends AccountState {}
class AccountSuccess extends AccountState {
  final AuthResponseDto response;
  AccountSuccess(this.response);
}
class AccountRegisterSuccess extends AccountState {}
class AccountFailure extends AccountState {
  final String error;
  AccountFailure(this.error);
}

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository repository;
  final SessionManager sessionManager = SessionManager();
  AccountCubit(this.repository) : super(AccountInitial());

  Future<void> login(AuthDto dto) async {
    emit(AccountLoading());
    try {
      final response = await repository.login(dto);
      await sessionManager.saveSession(response.token, response.user.toJson());
      emit(AccountSuccess(response));
    } catch (e) {
      emit(AccountFailure(e.toString()));
    }
  }

  Future<void> register(RegisterDto dto) async {
    emit(AccountLoading());
    try {
      await repository.register(dto);
      emit(AccountRegisterSuccess());
    } catch (e) {
      emit(AccountFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    await sessionManager.clearSession();
    emit(AccountInitial());
  }
} 