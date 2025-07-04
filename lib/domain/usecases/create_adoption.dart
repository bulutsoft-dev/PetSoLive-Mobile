import '../../data/models/adoption_dto.dart';
import '../repositories/adoption_repository.dart';

class CreateAdoption {
  final AdoptionRepository repository;
  CreateAdoption(this.repository);

  Future<void> call(AdoptionDto dto, String token) => repository.create(dto, token);
} 