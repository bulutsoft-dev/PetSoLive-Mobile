import '../../domain/repositories/admin_repository.dart';
import '../providers/admin_api_service.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminApiService apiService;

  AdminRepositoryImpl(this.apiService);

  @override
  Future<bool> isUserAdmin(int userId) => apiService.isUserAdmin(userId);
} 