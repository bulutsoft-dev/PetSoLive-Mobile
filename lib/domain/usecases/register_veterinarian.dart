import '../../data/models/veterinarian_dto.dart';
import '../repositories/veterinarian_repository.dart';

class RegisterVeterinarian {
  final VeterinarianRepository repository;
  RegisterVeterinarian(this.repository);

  Future<VeterinarianDto?> call(VeterinarianDto dto, String token) => repository.register(dto, token);
} 