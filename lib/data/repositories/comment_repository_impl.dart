import '../../domain/repositories/comment_repository.dart';
import '../models/comment_dto.dart';
import '../providers/comment_api_service.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentApiService apiService;

  CommentRepositoryImpl(this.apiService);

  @override
  Future<List<CommentDto>> getByHelpRequestId(int helpRequestId) =>
      apiService.getByHelpRequestId(helpRequestId);

  @override
  Future<void> add(CommentDto dto, String token) => apiService.add(dto, token);

  @override
  Future<void> delete(int id, String token) => apiService.delete(id, token);
} 