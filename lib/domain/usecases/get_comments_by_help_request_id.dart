import '../../data/models/comment_dto.dart';
import '../repositories/comment_repository.dart';

class GetCommentsByHelpRequestId {
  final CommentRepository repository;
  GetCommentsByHelpRequestId(this.repository);

  Future<List<CommentDto>> call(int helpRequestId) => repository.getByHelpRequestId(helpRequestId);
} 