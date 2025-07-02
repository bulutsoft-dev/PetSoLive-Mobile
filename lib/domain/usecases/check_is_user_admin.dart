import '../repositories/admin_repository.dart';

class CheckIsUserAdmin {
  final AdminRepository repository;
  CheckIsUserAdmin(this.repository);

  Future<bool> call(int userId) => repository.isUserAdmin(userId);
} 