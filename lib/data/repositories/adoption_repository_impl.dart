import '../../domain/entities/adoption.dart';
import '../../domain/repositories/adoption_repository.dart';
import '../models/adoption_dto.dart';
import '../providers/adoption_api_service.dart';

class AdoptionRepositoryImpl implements AdoptionRepository {
  final AdoptionApiService apiService;

  AdoptionRepositoryImpl({required this.apiService});

  @override
  Future<List<Adoption>> getAll() async {
    final dtos = await apiService.getAdoptions();
    return dtos.map((dto) => Adoption(
      id: dto.id,
      petId: dto.petId,
      adopterId: dto.adopterId,
      adoptionDate: dto.adoptionDate,
    )).toList();
  }

  @override
  Future<Adoption> getById(int id) async {
    final dto = await apiService.getAdoption(id);
    return Adoption(
      id: dto.id,
      petId: dto.petId,
      adopterId: dto.adopterId,
      adoptionDate: dto.adoptionDate,
    );
  }

  @override
  Future<void> create(Adoption adoption) async {
    final dto = AdoptionDto(
      id: adoption.id,
      petId: adoption.petId,
      adopterId: adoption.adopterId,
      adoptionDate: adoption.adoptionDate,
    );
    await apiService.createAdoption(dto);
  }

  @override
  Future<void> update(int id, Adoption adoption) async {
    final dto = AdoptionDto(
      id: adoption.id,
      petId: adoption.petId,
      adopterId: adoption.adopterId,
      adoptionDate: adoption.adoptionDate,
    );
    await apiService.updateAdoption(id, dto);
  }

  @override
  Future<void> delete(int id) async {
    await apiService.deleteAdoption(id);
  }
} 