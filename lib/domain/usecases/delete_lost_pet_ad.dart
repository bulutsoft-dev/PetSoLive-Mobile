import '../repositories/lost_pet_ad_repository.dart';

class DeleteLostPetAd {
  final LostPetAdRepository repository;
  DeleteLostPetAd(this.repository);

  Future<void> call(int id, String token) => repository.delete(id, token);
} 