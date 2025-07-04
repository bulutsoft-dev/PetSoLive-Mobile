import '../../data/models/user_dto.dart';
import '../repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repository;
  UpdateUser(this.repository);

  Future<void> call(int id, UserDto dto, String token) => repository.update(id, dto, token);
} 