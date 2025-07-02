import '../../data/models/lost_pet_ad_dto.dart';
import '../repositories/lost_pet_ad_repository.dart';

class GetLostPetAdById {
  final LostPetAdRepository repository;
  GetLostPetAdById(this.repository);

  Future<LostPetAdDto?> call(int id) => repository.getById(id);
} 