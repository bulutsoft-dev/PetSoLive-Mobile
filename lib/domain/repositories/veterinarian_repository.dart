import '../entities/veterinarian.dart';

abstract class VeterinarianRepository {
  Future<List<Veterinarian>> getAll();
  Future<Veterinarian> getById(int id);
  Future<void> create(Veterinarian vet);
  Future<void> update(int id, Veterinarian vet);
  Future<void> delete(int id);
} 