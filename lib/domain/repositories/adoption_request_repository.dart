import '../../data/models/adoption_request_dto.dart';

abstract class AdoptionRequestRepository {
  Future<AdoptionRequestDto?> getById(int id);
} 