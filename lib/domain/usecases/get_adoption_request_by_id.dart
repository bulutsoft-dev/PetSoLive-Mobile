import '../../data/models/adoption_request_dto.dart';
import '../repositories/adoption_request_repository.dart';

class GetAdoptionRequestById {
  final AdoptionRequestRepository repository;
  GetAdoptionRequestById(this.repository);

  Future<AdoptionRequestDto?> call(int id) => repository.getById(id);
} 