import '../../data/models/veterinarian_dto.dart';
import '../repositories/veterinarian_repository.dart';

class GetVeterinarians {
  final VeterinarianRepository repository;
  GetVeterinarians(this.repository);

  Future<List<VeterinarianDto>> call() => repository.getAll();
} 