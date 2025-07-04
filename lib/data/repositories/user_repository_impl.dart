import '../../domain/repositories/user_repository.dart';
import '../models/user_dto.dart';
import '../providers/user_api_service.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiService apiService;

  UserRepositoryImpl(this.apiService);

  @override
  Future<List<UserDto>> getAll() => apiService.getAll();

  @override
  Future<UserDto?> getById(int id) => apiService.getById(id);

  @override
  Future<void> update(int id, UserDto dto, String token) => apiService.update(id, dto, token);
} 