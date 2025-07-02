import '../../data/models/help_request_dto.dart';

abstract class HelpRequestRepository {
  Future<List<HelpRequestDto>> getAll();
  Future<HelpRequestDto?> getById(int id);
  Future<void> create(HelpRequestDto dto, String token);
  Future<void> update(int id, HelpRequestDto dto, String token);
  Future<void> delete(int id, String token);
} 