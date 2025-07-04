import '../../data/models/adoption_dto.dart';

abstract class AdoptionRepository {
  Future<AdoptionDto?> getByPetId(int petId);
  Future<void> create(AdoptionDto dto, String token);
} 