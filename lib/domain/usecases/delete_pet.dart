import '../repositories/pet_repository.dart';

class DeletePet {
  final PetRepository repository;
  DeletePet(this.repository);

  Future<void> call(int id, String token) => repository.delete(id, token);
} 