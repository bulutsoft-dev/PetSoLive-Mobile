import '../../domain/entities/veterinarian.dart';
import '../../domain/repositories/veterinarian_repository.dart';
import '../models/veterinarian_dto.dart';
import '../providers/veterinarian_api_service.dart';

class VeterinarianRepositoryImpl implements VeterinarianRepository {
  final VeterinarianApiService apiService;

  VeterinarianRepositoryImpl({required this.apiService});

  @override
  Future<List<Veterinarian>> getAll() async {
    final dtos = await apiService.getVeterinarians();
    return dtos.map((dto) => Veterinarian(
      id: dto.id,
      name: dto.name,
      clinicName: dto.clinicName,
      phoneNumber: dto.phoneNumber,
      email: dto.email,
      address: dto.address,
    )).toList();
  }

  @override
  Future<Veterinarian> getById(int id) async {
    final dto = await apiService.getVeterinarian(id);
    return Veterinarian(
      id: dto.id,
      name: dto.name,
      clinicName: dto.clinicName,
      phoneNumber: dto.phoneNumber,
      email: dto.email,
      address: dto.address,
    );
  }

  @override
  Future<void> create(Veterinarian vet) async {
    final dto = VeterinarianDto(
      id: vet.id,
      name: vet.name,
      clinicName: vet.clinicName,
      phoneNumber: vet.phoneNumber,
      email: vet.email,
      address: vet.address,
    );
    await apiService.createVeterinarian(dto);
  }

  @override
  Future<void> update(int id, Veterinarian vet) async {
    final dto = VeterinarianDto(
      id: vet.id,
      name: vet.name,
      clinicName: vet.clinicName,
      phoneNumber: vet.phoneNumber,
      email: vet.email,
      address: vet.address,
    );
    await apiService.updateVeterinarian(id, dto);
  }

  @override
  Future<void> delete(int id) async {
    await apiService.deleteVeterinarian(id);
  }
} 