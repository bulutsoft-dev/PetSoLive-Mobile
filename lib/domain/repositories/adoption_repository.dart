import '../entities/adoption.dart';

abstract class AdoptionRepository {
  Future<List<Adoption>> getAll();
  Future<Adoption> getById(int id);
  Future<void> create(Adoption adoption);
  Future<void> update(int id, Adoption adoption);
  Future<void> delete(int id);
} 