import '../../domain/entities/help_request.dart';
import '../../domain/repositories/help_request_repository.dart';
import '../models/help_request_dto.dart';
import '../providers/help_request_api_service.dart';

class HelpRequestRepositoryImpl implements HelpRequestRepository {
  final HelpRequestApiService apiService;

  HelpRequestRepositoryImpl({required this.apiService});

  @override
  Future<List<HelpRequest>> getAll() async {
    final dtos = await apiService.getHelpRequests();
    return dtos.map((dto) => HelpRequest(
      id: dto.id,
      userId: dto.userId,
      description: dto.description,
      emergencyLevel: dto.emergencyLevel,
      createdAt: dto.createdAt,
    )).toList();
  }

  @override
  Future<HelpRequest> getById(int id) async {
    final dto = await apiService.getHelpRequest(id);
    return HelpRequest(
      id: dto.id,
      userId: dto.userId,
      description: dto.description,
      emergencyLevel: dto.emergencyLevel,
      createdAt: dto.createdAt,
    );
  }

  @override
  Future<void> create(HelpRequest helpRequest) async {
    final dto = HelpRequestDto(
      id: helpRequest.id,
      userId: helpRequest.userId,
      description: helpRequest.description,
      emergencyLevel: helpRequest.emergencyLevel,
      createdAt: helpRequest.createdAt,
    );
    await apiService.createHelpRequest(dto);
  }

  @override
  Future<void> update(int id, HelpRequest helpRequest) async {
    final dto = HelpRequestDto(
      id: helpRequest.id,
      userId: helpRequest.userId,
      description: helpRequest.description,
      emergencyLevel: helpRequest.emergencyLevel,
      createdAt: helpRequest.createdAt,
    );
    await apiService.updateHelpRequest(id, dto);
  }

  @override
  Future<void> delete(int id) async {
    await apiService.deleteHelpRequest(id);
  }
} 