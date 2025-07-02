import '../repositories/help_request_repository.dart';

class DeleteHelpRequest {
  final HelpRequestRepository repository;
  DeleteHelpRequest(this.repository);

  Future<void> call(int id, String token) => repository.delete(id, token);
} 