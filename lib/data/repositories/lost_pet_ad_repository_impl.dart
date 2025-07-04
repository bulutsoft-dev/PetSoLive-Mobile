import '../../domain/repositories/lost_pet_ad_repository.dart';
import '../models/lost_pet_ad_dto.dart';
import '../providers/lost_pet_ad_api_service.dart';

class LostPetAdRepositoryImpl implements LostPetAdRepository {
  final LostPetAdApiService apiService;

  LostPetAdRepositoryImpl(this.apiService);

  @override
  Future<List<LostPetAdDto>> getAll() => apiService.getAll();

  @override
  Future<LostPetAdDto?> getById(int id) => apiService.getById(id);

  @override
  Future<void> create(LostPetAdDto dto, String token) => apiService.create(dto, token);

  @override
  Future<void> update(int id, LostPetAdDto dto, String token) => apiService.update(id, dto, token);

  @override
  Future<void> delete(int id, String token) => apiService.delete(id, token);
} 