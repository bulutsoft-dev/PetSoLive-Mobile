import '../../domain/repositories/adoption_request_repository.dart';
import '../models/adoption_request_dto.dart';
import '../providers/adoption_request_api_service.dart';

class AdoptionRequestRepositoryImpl implements AdoptionRequestRepository {
  final AdoptionRequestApiService apiService;

  AdoptionRequestRepositoryImpl(this.apiService);

  @override
  Future<AdoptionRequestDto?> getById(int id) => apiService.getById(id);
} 