import '../entities/adoption_request.dart';

abstract class AdoptionRequestRepository {
  Future<List<AdoptionRequest>> getAll();
  Future<AdoptionRequest> getById(int id);
  Future<void> create(AdoptionRequest request);
  Future<void> update(int id, AdoptionRequest request);
  Future<void> delete(int id);
} 