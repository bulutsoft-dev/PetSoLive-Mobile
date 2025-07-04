import '../../domain/repositories/veterinarian_repository.dart';
import '../models/veterinarian_dto.dart';
import '../providers/veterinarian_api_service.dart';

class VeterinarianRepositoryImpl implements VeterinarianRepository {
  final VeterinarianApiService apiService;

  VeterinarianRepositoryImpl(this.apiService);

  @override
  Future<List<VeterinarianDto>> getAll() => apiService.getAll();

  @override
  Future<VeterinarianDto?> register(VeterinarianDto dto, String token) => apiService.register(dto, token);

  @override
  Future<void> approve(int id, String token) => apiService.approve(id, token);

  @override
  Future<void> reject(int id, String token) => apiService.reject(id, token);
} 