import '../../data/models/lost_pet_ad_dto.dart';
import '../repositories/lost_pet_ad_repository.dart';

class CreateLostPetAd {
  final LostPetAdRepository repository;
  CreateLostPetAd(this.repository);

  Future<void> call(LostPetAdDto dto, String token) => repository.create(dto, token);
} 