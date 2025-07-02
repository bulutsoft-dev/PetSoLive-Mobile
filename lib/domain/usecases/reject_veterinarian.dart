import '../repositories/veterinarian_repository.dart';

class RejectVeterinarian {
  final VeterinarianRepository repository;
  RejectVeterinarian(this.repository);

  Future<void> call(int id, String token) => repository.reject(id, token);
} 