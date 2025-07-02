import '../entities/lost_pet_ad.dart';

abstract class LostPetAdRepository {
  Future<List<LostPetAd>> getAll();
  Future<LostPetAd> getById(int id);
  Future<void> create(LostPetAd ad);
  Future<void> update(int id, LostPetAd ad);
  Future<void> delete(int id);
} 