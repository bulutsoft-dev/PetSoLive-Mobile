import '../entities/pet_owner.dart';

abstract class PetOwnerRepository {
  Future<List<PetOwner>> getAll();
  Future<PetOwner> getById(int id);
  Future<void> create(PetOwner owner);
  Future<void> update(int id, PetOwner owner);
  Future<void> delete(int id);
} 