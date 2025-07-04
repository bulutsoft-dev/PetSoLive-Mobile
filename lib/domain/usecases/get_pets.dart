import '../../data/models/pet_dto.dart';
import '../repositories/pet_repository.dart';

class GetPets {
  final PetRepository repository;
  GetPets(this.repository);

  Future<List<PetDto>> call() => repository.getAll();
} 