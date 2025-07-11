import '../../data/models/comment_dto.dart';

abstract class CommentRepository {
  Future<List<CommentDto>> getByHelpRequestId(int helpRequestId);
  Future<void> add(CommentDto dto, String token);
  Future<void> delete(int id, String token);
  Future<void> update(int id, CommentDto dto, String token);
} 