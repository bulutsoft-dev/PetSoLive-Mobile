import '../../data/models/pet_dto.dart';
import '../../domain/entities/pet.dart';

abstract class PetRepository {
  Future<List<PetDto>> getPets();
  Future<List<PetDto>> getAll();
  Future<PetDto?> getById(int id);
  Future<void> create(PetDto dto, String token);
  Future<void> update(int id, PetDto dto, String token);
  Future<void> delete(int id, String token);
} 