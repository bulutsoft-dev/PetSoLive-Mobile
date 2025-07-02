import '../entities/help_request.dart';

abstract class HelpRequestRepository {
  Future<List<HelpRequest>> getAll();
  Future<HelpRequest> getById(int id);
  Future<void> create(HelpRequest helpRequest);
  Future<void> update(int id, HelpRequest helpRequest);
  Future<void> delete(int id);
} 