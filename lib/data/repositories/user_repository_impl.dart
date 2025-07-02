import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_dto.dart';
import '../providers/user_api_service.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiService apiService;

  UserRepositoryImpl({required this.apiService});

  @override
  Future<List<User>> getAll() async {
    final dtos = await apiService.getUsers();
    return dtos.map((dto) => User(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      phoneNumber: dto.phoneNumber,
      address: dto.address,
      createdAt: dto.createdAt,
    )).toList();
  }

  @override
  Future<User> getById(int id) async {
    final dto = await apiService.getUser(id);
    return User(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      phoneNumber: dto.phoneNumber,
      address: dto.address,
      createdAt: dto.createdAt,
    );
  }

  @override
  Future<void> create(User user) async {
    final dto = UserDto(
      id: user.id,
      name: user.name,
      email: user.email,
      phoneNumber: user.phoneNumber,
      address: user.address,
      createdAt: user.createdAt,
    );
    await apiService.createUser(dto);
  }

  @override
  Future<void> update(int id, User user) async {
    final dto = UserDto(
      id: user.id,
      name: user.name,
      email: user.email,
      phoneNumber: user.phoneNumber,
      address: user.address,
      createdAt: user.createdAt,
    );
    await apiService.updateUser(id, dto);
  }

  @override
  Future<void> delete(int id) async {
    await apiService.deleteUser(id);
  }
} 