import '../../data/models/adoption_dto.dart';
import '../repositories/adoption_repository.dart';

class GetAdoptionByPetId {
  final AdoptionRepository repository;
  GetAdoptionByPetId(this.repository);

  Future<AdoptionDto?> call(int petId) => repository.getByPetId(petId);
} 