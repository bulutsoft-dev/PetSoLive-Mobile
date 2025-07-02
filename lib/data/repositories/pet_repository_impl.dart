import '../../domain/repositories/pet_repository.dart';
import '../models/pet_dto.dart';
import '../providers/pet_api_service.dart';

class PetRepositoryImpl implements PetRepository {
  final PetApiService apiService;

  PetRepositoryImpl(this.apiService);

  @override
  Future<List<PetDto>> getAll() => apiService.getAll();

  @override
  Future<PetDto?> getById(int id) => apiService.getById(id);

  @override
  Future<void> create(PetDto dto, String token) => apiService.create(dto, token);

  @override
  Future<void> update(int id, PetDto dto, String token) => apiService.update(id, dto, token);

  @override
  Future<void> delete(int id, String token) => apiService.delete(id, token);
} 