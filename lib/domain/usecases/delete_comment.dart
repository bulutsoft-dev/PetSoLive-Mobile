import '../repositories/comment_repository.dart';

class DeleteComment {
  final CommentRepository repository;
  DeleteComment(this.repository);

  Future<void> call(int id, String token) => repository.delete(id, token);
} 