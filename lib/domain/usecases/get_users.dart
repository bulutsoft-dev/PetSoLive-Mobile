import '../../data/models/user_dto.dart';
import '../repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;
  GetUsers(this.repository);

  Future<List<UserDto>> call() => repository.getAll();
} 