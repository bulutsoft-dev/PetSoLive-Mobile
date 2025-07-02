import '../../data/models/lost_pet_ad_dto.dart';

abstract class LostPetAdRepository {
  Future<List<LostPetAdDto>> getAll();
  Future<LostPetAdDto?> getById(int id);
  Future<void> create(LostPetAdDto dto, String token);
  Future<void> update(int id, LostPetAdDto dto, String token);
  Future<void> delete(int id, String token);
} 