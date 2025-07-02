import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../models/pet_dto.dart';
import '../providers/pet_api_service.dart';

class PetRepositoryImpl implements PetRepository {
  final PetApiService apiService;

  PetRepositoryImpl({required this.apiService});

  @override
  Future<List<Pet>> getAll() async {
    final dtos = await apiService.getPets();
    return dtos.map((dto) => Pet(
      id: dto.id,
      name: dto.name,
      species: dto.species,
      breed: dto.breed,
      age: dto.age,
      gender: dto.gender,
      ownerId: dto.ownerId,
      imageUrl: dto.imageUrl,
    )).toList();
  }

  @override
  Future<Pet> getById(int id) async {
    final dto = await apiService.getPet(id);
    return Pet(
      id: dto.id,
      name: dto.name,
      species: dto.species,
      breed: dto.breed,
      age: dto.age,
      gender: dto.gender,
      ownerId: dto.ownerId,
      imageUrl: dto.imageUrl,
    );
  }

  @override
  Future<void> create(Pet pet) async {
    final dto = PetDto(
      id: pet.id,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      age: pet.age,
      gender: pet.gender,
      ownerId: pet.ownerId,
      imageUrl: pet.imageUrl,
    );
    await apiService.createPet(dto);
  }

  @override
  Future<void> update(int id, Pet pet) async {
    final dto = PetDto(
      id: pet.id,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      age: pet.age,
      gender: pet.gender,
      ownerId: pet.ownerId,
      imageUrl: pet.imageUrl,
    );
    await apiService.updatePet(id, dto);
  }

  @override
  Future<void> delete(int id) async {
    await apiService.deletePet(id);
  }
} 