import '../../data/models/veterinarian_dto.dart';

abstract class VeterinarianRepository {
  Future<List<VeterinarianDto>> getAll();
  Future<VeterinarianDto?> register(VeterinarianDto dto, String token);
  Future<void> approve(int id, String token);
  Future<void> reject(int id, String token);
} 