import '../../data/models/lost_pet_ad_dto.dart';
import '../repositories/lost_pet_ad_repository.dart';

class GetLostPetAds {
  final LostPetAdRepository repository;
  GetLostPetAds(this.repository);

  Future<List<LostPetAdDto>> call() => repository.getAll();
} 