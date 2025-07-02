import '../../domain/entities/adoption_request.dart';
import '../../domain/repositories/adoption_request_repository.dart';
import '../models/adoption_request_dto.dart';
import '../providers/adoption_request_api_service.dart';

class AdoptionRequestRepositoryImpl implements AdoptionRequestRepository {
  final AdoptionRequestApiService apiService;

  AdoptionRequestRepositoryImpl({required this.apiService});

  @override
  Future<List<AdoptionRequest>> getAll() async {
    final dtos = await apiService.getAdoptionRequests();
    return dtos.map((dto) => AdoptionRequest(
      id: dto.id,
      adoptionId: dto.adoptionId,
      requesterId: dto.requesterId,
      status: dto.status,
      requestDate: dto.requestDate,
    )).toList();
  }

  @override
  Future<AdoptionRequest> getById(int id) async {
    final dto = await apiService.getAdoptionRequest(id);
    return AdoptionRequest(
      id: dto.id,
      adoptionId: dto.adoptionId,
      requesterId: dto.requesterId,
      status: dto.status,
      requestDate: dto.requestDate,
    );
  }

  @override
  Future<void> create(AdoptionRequest request) async {
    final dto = AdoptionRequestDto(
      id: request.id,
      adoptionId: request.adoptionId,
      requesterId: request.requesterId,
      status: request.status,
      requestDate: request.requestDate,
    );
    await apiService.createAdoptionRequest(dto);
  }

  @override
  Future<void> update(int id, AdoptionRequest request) async {
    final dto = AdoptionRequestDto(
      id: request.id,
      adoptionId: request.adoptionId,
      requesterId: request.requesterId,
      status: request.status,
      requestDate: request.requestDate,
    );
    await apiService.updateAdoptionRequest(id, dto);
  }

  @override
  Future<void> delete(int id) async {
    await apiService.deleteAdoptionRequest(id);
  }
} 