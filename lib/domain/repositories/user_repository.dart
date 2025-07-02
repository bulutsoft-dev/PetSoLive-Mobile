import '../../data/models/user_dto.dart';

abstract class UserRepository {
  Future<List<UserDto>> getAll();
  Future<UserDto?> getById(int id);
  Future<void> update(int id, UserDto dto, String token);
} 