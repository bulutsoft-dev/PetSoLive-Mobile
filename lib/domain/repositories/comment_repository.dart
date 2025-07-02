import '../entities/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getAll();
  Future<Comment> getById(int id);
  Future<void> create(Comment comment);
  Future<void> update(int id, Comment comment);
  Future<void> delete(int id);
} 