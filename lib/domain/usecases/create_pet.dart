import '../../data/models/pet_dto.dart';
import '../repositories/pet_repository.dart';

class CreatePet {
  final PetRepository repository;
  CreatePet(this.repository);

  Future<void> call(PetDto dto, String token) => repository.create(dto, token);
} 