import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/comment.dart';
import '../../data/repositories/comment_repository_impl.dart';

// Events
abstract class CommentEvent {}
class LoadComments extends CommentEvent {}
class AddComment extends CommentEvent {
  final Comment comment;
  AddComment(this.comment);
}
class UpdateComment extends CommentEvent {
  final int id;
  final Comment comment;
  UpdateComment(this.id, this.comment);
}
class DeleteComment extends CommentEvent {
  final int id;
  DeleteComment(this.id);
}

// States
abstract class CommentState {}
class CommentInitial extends CommentState {}
class CommentLoading extends CommentState {}
class CommentLoaded extends CommentState {
  final List<Comment> comments;
  CommentLoaded(this.comments);
}
class CommentError extends CommentState {
  final String message;
  CommentError(this.message);
}

// Bloc
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepositoryImpl repository;
  CommentBloc(this.repository) : super(CommentInitial()) {
    on<LoadComments>((event, emit) async {
      emit(CommentLoading());
      try {
        final comments = await repository.getAll();
        emit(CommentLoaded(comments));
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    });
    on<AddComment>((event, emit) async {
      try {
        await repository.create(event.comment);
        add(LoadComments());
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    });
    on<UpdateComment>((event, emit) async {
      try {
        await repository.update(event.id, event.comment);
        add(LoadComments());
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    });
    on<DeleteComment>((event, emit) async {
      try {
        await repository.delete(event.id);
        add(LoadComments());
      } catch (e) {
        emit(CommentError(e.toString()));
      }
    });
  }
} 