import '../../data/models/auth_dto.dart';
import '../../data/models/register_dto.dart';
import '../../data/models/auth_response_dto.dart';

abstract class AccountRepository {
  Future<AuthResponseDto> login(AuthDto dto);
  Future<void> register(RegisterDto dto);
} 