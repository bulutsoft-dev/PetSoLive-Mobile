import '../../data/models/lost_pet_ad_dto.dart';
import '../repositories/lost_pet_ad_repository.dart';

class UpdateLostPetAd {
  final LostPetAdRepository repository;
  UpdateLostPetAd(this.repository);

  Future<void> call(int id, LostPetAdDto dto, String token) => repository.update(id, dto, token);
} 