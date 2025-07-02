import '../entities/pet.dart';

abstract class PetRepository {
  Future<List<Pet>> getAll();
  Future<Pet> getById(int id);
  Future<void> create(Pet pet);
  Future<void> update(int id, Pet pet);
  Future<void> delete(int id);
} 