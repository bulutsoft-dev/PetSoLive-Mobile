import '../../domain/entities/lost_pet_ad.dart';
import '../../domain/repositories/lost_pet_ad_repository.dart';
import '../models/lost_pet_ad_dto.dart';
import '../providers/lost_pet_ad_api_service.dart';

class LostPetAdRepositoryImpl implements LostPetAdRepository {
  final LostPetAdApiService apiService;

  LostPetAdRepositoryImpl({required this.apiService});

  @override
  Future<List<LostPetAd>> getAll() async {
    final dtos = await apiService.getLostPetAds();
    return dtos.map((dto) => LostPetAd(
      id: dto.id,
      petId: dto.petId,
      lastSeenLocation: dto.lastSeenLocation,
      lostDate: dto.lostDate,
      status: dto.status,
    )).toList();
  }

  @override
  Future<LostPetAd> getById(int id) async {
    final dto = await apiService.getLostPetAd(id);
    return LostPetAd(
      id: dto.id,
      petId: dto.petId,
      lastSeenLocation: dto.lastSeenLocation,
      lostDate: dto.lostDate,
      status: dto.status,
    );
  }

  @override
  Future<void> create(LostPetAd ad) async {
    final dto = LostPetAdDto(
      id: ad.id,
      petId: ad.petId,
      lastSeenLocation: ad.lastSeenLocation,
      lostDate: ad.lostDate,
      status: ad.status,
    );
    await apiService.createLostPetAd(dto);
  }

  @override
  Future<void> update(int id, LostPetAd ad) async {
    final dto = LostPetAdDto(
      id: ad.id,
      petId: ad.petId,
      lastSeenLocation: ad.lastSeenLocation,
      lostDate: ad.lostDate,
      status: ad.status,
    );
    await apiService.updateLostPetAd(id, dto);
  }

  @override
  Future<void> delete(int id) async {
    await apiService.deleteLostPetAd(id);
  }
} 