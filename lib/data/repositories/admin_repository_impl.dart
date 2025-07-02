import '../../domain/entities/admin.dart';
import '../../domain/repositories/admin_repository.dart';
import '../models/admin_dto.dart';
import '../providers/admin_api_service.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminApiService apiService;

  AdminRepositoryImpl({required this.apiService});

  @override
  Future<List<Admin>> getAll() async {
    final dtos = await apiService.getAdmins();
    return dtos.map((dto) => Admin(
      id: dto.id,
      name: dto.name,
      email: dto.email,
    )).toList();
  }

  @override
  Future<Admin> getById(int id) async {
    final dto = await apiService.getAdmin(id);
    return Admin(
      id: dto.id,
      name: dto.name,
      email: dto.email,
    );
  }

  @override
  Future<void> create(Admin admin) async {
    final dto = AdminDto(
      id: admin.id,
      name: admin.name,
      email: admin.email,
    );
    await apiService.createAdmin(dto);
  }

  @override
  Future<void> update(int id, Admin admin) async {
    final dto = AdminDto(
      id: admin.id,
      name: admin.name,
      email: admin.email,
    );
    await apiService.updateAdmin(id, dto);
  }

  @override
  Future<void> delete(int id) async {
    await apiService.deleteAdmin(id);
  }
} 