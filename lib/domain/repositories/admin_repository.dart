import '../entities/admin.dart';

abstract class AdminRepository {
  Future<List<Admin>> getAll();
  Future<Admin> getById(int id);
  Future<void> create(Admin admin);
  Future<void> update(int id, Admin admin);
  Future<void> delete(int id);
} 