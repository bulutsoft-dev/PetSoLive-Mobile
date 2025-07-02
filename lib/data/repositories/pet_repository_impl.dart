import '../../domain/repositories/pet_repository.dart';
import '../models/pet_dto.dart';
import '../providers/pet_api_service.dart';
import '../../domain/entities/pet.dart';

class PetRepositoryImpl implements PetRepository {
  final PetApiService apiService;

  PetRepositoryImpl(this.apiService);

  @override
  Future<List<Pet>> getPets() async {
    final dtos = await apiService.getAll();
    return dtos.map((dto) => Pet(
      id: dto.id,
      name: dto.name,
      species: dto.species,
      breed: dto.breed,
      age: dto.age,
      gender: dto.gender,
      weight: dto.weight,
      color: dto.color,
      dateOfBirth: dto.dateOfBirth,
      description: dto.description,
      vaccinationStatus: dto.vaccinationStatus,
      microchipId: dto.microchipId,
      isNeutered: dto.isNeutered,
      imageUrl: dto.imageUrl,
      adoptionRequests: const [],
      petOwners: const [],
    )).toList();
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