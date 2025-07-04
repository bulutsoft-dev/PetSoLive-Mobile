import '../../domain/repositories/help_request_repository.dart';
import '../models/help_request_dto.dart';
import '../providers/help_request_api_service.dart';

class HelpRequestRepositoryImpl implements HelpRequestRepository {
  final HelpRequestApiService apiService;

  HelpRequestRepositoryImpl(this.apiService);

  @override
  Future<List<HelpRequestDto>> getAll() => apiService.getAll();

  @override
  Future<HelpRequestDto?> getById(int id) => apiService.getById(id);

  @override
  Future<void> create(HelpRequestDto dto, String token) => apiService.create(dto, token);

  @override
  Future<void> update(int id, HelpRequestDto dto, String token) => apiService.update(id, dto, token);

  @override
  Future<void> delete(int id, String token) => apiService.delete(id, token);
} 