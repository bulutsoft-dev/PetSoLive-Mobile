import '../../data/models/register_dto.dart';
import '../repositories/account_repository.dart';

class Register {
  final AccountRepository repository;
  Register(this.repository);

  Future<void> call(RegisterDto dto) => repository.register(dto);
} 