import '../entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getAll();
  Future<User> getById(int id);
  Future<void> create(User user);
  Future<void> update(int id, User user);
  Future<void> delete(int id);
} 