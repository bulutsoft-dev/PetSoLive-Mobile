import '../../data/models/pet_owner_dto.dart';

abstract class PetOwnerRepository {
  Future<PetOwnerDto?> getByPetId(int petId);
} 