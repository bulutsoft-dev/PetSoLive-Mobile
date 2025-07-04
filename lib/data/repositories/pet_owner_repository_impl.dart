import '../../domain/repositories/pet_owner_repository.dart';
import '../models/pet_owner_dto.dart';
import '../providers/pet_owner_api_service.dart';

class PetOwnerRepositoryImpl implements PetOwnerRepository {
  final PetOwnerApiService apiService;

  PetOwnerRepositoryImpl(this.apiService);

  @override
  Future<PetOwnerDto?> getByPetId(int petId) => apiService.getByPetId(petId);
} 