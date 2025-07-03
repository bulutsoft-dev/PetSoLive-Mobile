import '../../domain/repositories/account_repository.dart';
import '../providers/account_api_service.dart';
import '../models/auth_dto.dart';
import '../models/register_dto.dart';
import '../models/auth_response_dto.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountApiService apiService;

  AccountRepositoryImpl(this.apiService);

  @override
  Future<AuthResponseDto> login(AuthDto dto) => apiService.login(dto);

  @override
  Future<void> register(RegisterDto dto) => apiService.register(dto);
} 