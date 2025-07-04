import '../../data/models/pet_dto.dart';
import '../repositories/pet_repository.dart';

class UpdatePet {
  final PetRepository repository;
  UpdatePet(this.repository);

  Future<void> call(int id, PetDto dto, String token) => repository.update(id, dto, token);
} 