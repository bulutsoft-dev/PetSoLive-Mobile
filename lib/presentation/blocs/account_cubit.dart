import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/auth_dto.dart';
import '../../data/models/register_dto.dart';
import '../../data/models/auth_response_dto.dart';
import '../../domain/repositories/account_repository.dart';
import '../../data/local/session_manager.dart';
import '../../data/models/user_dto.dart';
import 'dart:io';

abstract class AccountState {}
class AccountInitial extends AccountState {}
class AccountLoading extends AccountState {}
class AccountSuccess extends AccountState {
  final AuthResponseDto response;
  AccountSuccess(this.response);
}
class AccountRegisterSuccess extends AccountState {
  final String? message;
  AccountRegisterSuccess([this.message]);
}
class AccountFailure extends AccountState {
  final String error;
  AccountFailure(this.error);
}

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository repository;
  final SessionManager sessionManager = SessionManager();
  AccountCubit(this.repository) : super(AccountInitial());

  Future<void> checkSession() async {
    final token = await sessionManager.getToken();
    final userJson = await sessionManager.getUser();
    if (token != null && userJson != null) {
      final user = UserDto.fromJson(userJson);
      emit(AccountSuccess(AuthResponseDto(token: token, user: user)));
    } else {
      emit(AccountInitial());
    }
  }

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
      final response = await repository.register(dto);
      // Eğer register sonrası response token ve user dönerse session kaydet
      if (response != null && response.token != null && response.user != null) {
        await sessionManager.saveSession(response.token, response.user.toJson());
        emit(AccountSuccess(response));
      } else {
        emit(AccountRegisterSuccess());
      }
    } catch (e) {
      final msg = e.toString();
      if (msg.startsWith('Exception: REGISTER_SUCCESS_MESSAGE:')) {
        final successMsg = msg.replaceFirst('Exception: REGISTER_SUCCESS_MESSAGE:', '');
        emit(AccountRegisterSuccess(successMsg));
      } else {
        // Hata mesajını daha kullanıcı dostu hale getir
        String errorMessage = msg;
        if (msg.contains('415')) {
          errorMessage = 'error.unsupported_media_type';
        } else if (msg.contains('404')) {
          errorMessage = 'error.not_found_error';
        } else if (msg.contains('401')) {
          errorMessage = 'error.unauthorized_error';
        } else if (msg.contains('403')) {
          errorMessage = 'error.forbidden_error';
        } else if (msg.contains('500')) {
          errorMessage = 'error.internal_server_error';
        } else if (msg.contains('400')) {
          errorMessage = 'error.bad_request';
        } else {
          errorMessage = 'error.register_failed';
        }
        emit(AccountFailure(errorMessage));
      }
    }
  }

  Future<void> registerWithImage(RegisterDto dto, File profileImage) async {
    emit(AccountLoading());
    try {
      final response = await repository.registerWithImage(dto, profileImage);
      // Eğer register sonrası response token ve user dönerse session kaydet
      if (response != null && response.token != null && response.user != null) {
        await sessionManager.saveSession(response.token, response.user.toJson());
        emit(AccountSuccess(response));
      } else {
        emit(AccountRegisterSuccess());
      }
    } catch (e) {
      final msg = e.toString();
      if (msg.startsWith('Exception: REGISTER_SUCCESS_MESSAGE:')) {
        final successMsg = msg.replaceFirst('Exception: REGISTER_SUCCESS_MESSAGE:', '');
        emit(AccountRegisterSuccess(successMsg));
      } else {
        // Hata mesajını daha kullanıcı dostu hale getir
        String errorMessage = msg;
        if (msg.contains('415')) {
          errorMessage = 'error.unsupported_media_type';
        } else if (msg.contains('404')) {
          errorMessage = 'error.not_found_error';
        } else if (msg.contains('401')) {
          errorMessage = 'error.unauthorized_error';
        } else if (msg.contains('403')) {
          errorMessage = 'error.forbidden_error';
        } else if (msg.contains('500')) {
          errorMessage = 'error.internal_server_error';
        } else if (msg.contains('400')) {
          errorMessage = 'error.bad_request';
        } else {
          errorMessage = 'error.register_failed';
        }
        emit(AccountFailure(errorMessage));
      }
    }
  }

  Future<void> logout() async {
    await sessionManager.clearSession();
    emit(AccountInitial());
  }
} 