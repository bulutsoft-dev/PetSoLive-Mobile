import '../../domain/repositories/account_repository.dart';
import '../providers/account_api_service.dart';
import '../models/auth_dto.dart';
import '../models/register_dto.dart';
import '../models/auth_response_dto.dart';
import 'dart:io';

class AccountRepositoryImpl implements AccountRepository {
  final AccountApiService apiService;

  AccountRepositoryImpl(this.apiService);

  @override
  Future<AuthResponseDto> login(AuthDto dto) => apiService.login(dto);

  @override
  Future<AuthResponseDto?> register(RegisterDto dto) => apiService.register(dto);

  @override
  Future<AuthResponseDto?> registerWithImage(RegisterDto dto, File profileImage) => apiService.registerWithImage(dto, profileImage);
} 