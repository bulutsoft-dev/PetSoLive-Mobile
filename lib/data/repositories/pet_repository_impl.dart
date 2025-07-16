import '../../domain/repositories/pet_repository.dart';
import '../models/pet_dto.dart';
import '../providers/pet_api_service.dart';
import '../../domain/entities/pet.dart';
import '../local/pet_local_data_source.dart';

class PetRepositoryImpl implements PetRepository {
  final PetApiService apiService;
  final PetLocalDataSource localDataSource;

  PetRepositoryImpl(this.apiService, this.localDataSource);

  @override
  Future<List<PetDto>> getPets() async {
    // Önce localden veri çek
    final localDtos = await localDataSource.getPets();
    // Arka planda API'den veri çekip local veriyi güncelle
    apiService.getAll().then((dtos) async {
      await localDataSource.savePets(dtos);
    });
    return localDtos;
  }

  @override
  Future<PetDto?> getById(int id) => apiService.getById(id);

  @override
  Future<void> create(PetDto dto, String token) => apiService.create(dto, token);

  @override
  Future<void> update(int id, PetDto dto, String token) => apiService.update(id, dto, token);

  @override
  Future<void> delete(int id, String token) => apiService.delete(id, token);

  @override
  Future<List<PetDto>> getAll() => apiService.getAll();
} 