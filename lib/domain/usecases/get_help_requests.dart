import '../../data/models/help_request_dto.dart';
import '../repositories/help_request_repository.dart';

class GetHelpRequests {
  final HelpRequestRepository repository;
  GetHelpRequests(this.repository);

  Future<List<HelpRequestDto>> call() => repository.getAll();
} 