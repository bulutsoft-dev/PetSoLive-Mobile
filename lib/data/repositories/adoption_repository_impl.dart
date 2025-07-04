import '../../domain/repositories/adoption_repository.dart';
import '../models/adoption_dto.dart';
import '../providers/adoption_api_service.dart';

class AdoptionRepositoryImpl implements AdoptionRepository {
  final AdoptionApiService apiService;

  AdoptionRepositoryImpl(this.apiService);

  @override
  Future<AdoptionDto?> getByPetId(int petId) => apiService.getByPetId(petId);

  @override
  Future<void> create(AdoptionDto dto, String token) => apiService.create(dto, token);
} 