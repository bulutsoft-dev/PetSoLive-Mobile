import '../../data/models/user_dto.dart';
import '../repositories/user_repository.dart';

class GetUserById {
  final UserRepository repository;
  GetUserById(this.repository);

  Future<UserDto?> call(int id) => repository.getById(id);
} 