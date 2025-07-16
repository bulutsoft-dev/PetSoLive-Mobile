import '../../data/models/help_request_dto.dart';

abstract class HelpRequestRepository {
  /// Returns all help requests from local storage, updates in background from API.
  Future<List<HelpRequestDto>> getAll();
  /// Fetches from API, saves to local, and returns local data.
  Future<List<HelpRequestDto>> fetchFromApiAndSaveToLocal();
  Future<HelpRequestDto?> getById(int id);
  Future<void> create(HelpRequestDto dto, String token);
  Future<void> update(int id, HelpRequestDto dto, String token);
  Future<void> delete(int id, String token);
} 