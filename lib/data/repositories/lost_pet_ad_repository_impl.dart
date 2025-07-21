import '../../domain/repositories/lost_pet_ad_repository.dart';
import '../models/lost_pet_ad_dto.dart';
import '../providers/lost_pet_ad_api_service.dart';
import '../local/lost_pet_ad_local_data_source.dart';

class LostPetAdRepositoryImpl implements LostPetAdRepository {
  final LostPetAdApiService apiService;
  final LostPetAdLocalDataSource localDataSource;
  LostPetAdRepositoryImpl(this.apiService, this.localDataSource);

  @override
  Future<List<LostPetAdDto>> getAll() async {
    final localAds = await localDataSource.getAds();
    // Arka planda API'den veri çekip local veriyi güncelle
    apiService.getAll().then((ads) async {
      await localDataSource.saveAds(ads);
    });
    return localAds;
  }

  @override
  Future<LostPetAdDto?> getById(int id) => apiService.getById(id);

  @override
  Future<void> create(LostPetAdDto dto, String token) => apiService.create(dto, token);

  @override
  Future<void> update(int id, LostPetAdDto dto, String token) => apiService.update(id, dto, token);

  @override
  Future<void> delete(int id, String token) => apiService.delete(id, token);
} 