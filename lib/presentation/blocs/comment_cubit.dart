import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/comment_dto.dart';
import '../../domain/repositories/comment_repository.dart';

abstract class CommentState {}
class CommentInitial extends CommentState {}
class CommentLoading extends CommentState {}
class CommentLoaded extends CommentState {
  final List<CommentDto> comments;
  CommentLoaded(this.comments);
}
class CommentError extends CommentState {
  final String error;
  CommentError(this.error);
}

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository repository;
  CommentCubit(this.repository) : super(CommentInitial());

  Future<void> getByHelpRequestId(int helpRequestId) async {
    emit(CommentLoading());
    try {
      final comments = await repository.getByHelpRequestId(helpRequestId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> add(CommentDto dto, String token) async {
    emit(CommentLoading());
    try {
      await repository.add(dto, token);
      emit(CommentInitial());
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> delete(int id, String token) async {
    emit(CommentLoading());
    try {
      await repository.delete(id, token);
      emit(CommentInitial());
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
} 