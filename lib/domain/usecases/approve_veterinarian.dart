import '../repositories/veterinarian_repository.dart';

class ApproveVeterinarian {
  final VeterinarianRepository repository;
  ApproveVeterinarian(this.repository);

  Future<void> call(int id, String token) => repository.approve(id, token);
} 