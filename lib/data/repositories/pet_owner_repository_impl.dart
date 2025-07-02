import '../../domain/entities/pet_owner.dart';
import '../../domain/repositories/pet_owner_repository.dart';
import '../models/pet_owner_dto.dart';
import '../providers/pet_owner_api_service.dart';

class PetOwnerRepositoryImpl implements PetOwnerRepository {
  final PetOwnerApiService apiService;

  PetOwnerRepositoryImpl({required this.apiService});

  @override
  Future<List<PetOwner>> getAll() async {
    final dtos = await apiService.getPetOwners();
    return dtos.map((dto) => PetOwner(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      phoneNumber: dto.phoneNumber,
    )).toList();
  }

  @override
  Future<PetOwner> getById(int id) async {
    final dto = await apiService.getPetOwner(id);
    return PetOwner(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      phoneNumber: dto.phoneNumber,
    );
  }

  @override
  Future<void> create(PetOwner owner) async {
    final dto = PetOwnerDto(
      id: owner.id,
      name: owner.name,
      email: owner.email,
      phoneNumber: owner.phoneNumber,
    );
    await apiService.createPetOwner(dto);
  }

  @override
  Future<void> update(int id, PetOwner owner) async {
    final dto = PetOwnerDto(
      id: owner.id,
      name: owner.name,
      email: owner.email,
      phoneNumber: owner.phoneNumber,
    );
    await apiService.updatePetOwner(id, dto);
  }

  @override
  Future<void> delete(int id) async {
    await apiService.deletePetOwner(id);
  }
} 