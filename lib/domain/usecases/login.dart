import '../../data/models/auth_dto.dart';
import '../../data/models/auth_response_dto.dart';
import '../repositories/account_repository.dart';

class Login {
  final AccountRepository repository;
  Login(this.repository);

  Future<AuthResponseDto> call(AuthDto dto) => repository.login(dto);
} 