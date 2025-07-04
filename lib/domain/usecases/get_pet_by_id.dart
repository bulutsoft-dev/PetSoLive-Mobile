import '../../data/models/pet_dto.dart';
import '../repositories/pet_repository.dart';

class GetPetById {
  final PetRepository repository;
  GetPetById(this.repository);

  Future<PetDto?> call(int id) => repository.getById(id);
} 