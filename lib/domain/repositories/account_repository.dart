import '../../data/models/auth_dto.dart';
import '../../data/models/register_dto.dart';
import '../../data/models/auth_response_dto.dart';
import 'dart:io';

abstract class AccountRepository {
  Future<AuthResponseDto> login(AuthDto dto);
  Future<AuthResponseDto?> register(RegisterDto dto);
  Future<AuthResponseDto?> registerWithImage(RegisterDto dto, File profileImage);
} 