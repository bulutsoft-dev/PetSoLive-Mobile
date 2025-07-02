import '../../domain/entities/comment.dart';
import '../../domain/repositories/comment_repository.dart';
import '../models/comment_dto.dart';
import '../providers/comment_api_service.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentApiService apiService;

  CommentRepositoryImpl({required this.apiService});

  @override
  Future<List<Comment>> getAll() async {
    final dtos = await apiService.getComments();
    return dtos.map((dto) => Comment(
      id: dto.id,
      userId: dto.userId,
      content: dto.content,
      createdAt: dto.createdAt,
    )).toList();
  }

  @override
  Future<Comment> getById(int id) async {
    final dto = await apiService.getComment(id);
    return Comment(
      id: dto.id,
      userId: dto.userId,
      content: dto.content,
      createdAt: dto.createdAt,
    );
  }

  @override
  Future<void> create(Comment comment) async {
    final dto = CommentDto(
      id: comment.id,
      userId: comment.userId,
      content: comment.content,
      createdAt: comment.createdAt,
    );
    await apiService.createComment(dto);
  }

  @override
  Future<void> update(int id, Comment comment) async {
    final dto = CommentDto(
      id: comment.id,
      userId: comment.userId,
      content: comment.content,
      createdAt: comment.createdAt,
    );
    await apiService.updateComment(id, dto);
  }

  @override
  Future<void> delete(int id) async {
    await apiService.deleteComment(id);
  }
} 