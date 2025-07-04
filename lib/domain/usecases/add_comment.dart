import '../../data/models/comment_dto.dart';
import '../repositories/comment_repository.dart';

class AddComment {
  final CommentRepository repository;
  AddComment(this.repository);

  Future<void> call(CommentDto dto, String token) => repository.add(dto, token);
} 