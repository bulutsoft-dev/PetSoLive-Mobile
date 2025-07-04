import '../../data/models/pet_owner_dto.dart';
import '../repositories/pet_owner_repository.dart';

class GetPetOwnerByPetId {
  final PetOwnerRepository repository;
  GetPetOwnerByPetId(this.repository);

  Future<PetOwnerDto?> call(int petId) => repository.getByPetId(petId);
} 