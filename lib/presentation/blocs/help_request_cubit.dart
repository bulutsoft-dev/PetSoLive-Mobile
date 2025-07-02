import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/help_request_dto.dart';
import '../../domain/repositories/help_request_repository.dart';

abstract class HelpRequestState {}
class HelpRequestInitial extends HelpRequestState {}
class HelpRequestLoading extends HelpRequestState {}
class HelpRequestLoaded extends HelpRequestState {
  final List<HelpRequestDto> helpRequests;
  HelpRequestLoaded(this.helpRequests);
}
class HelpRequestDetailLoaded extends HelpRequestState {
  final HelpRequestDto? helpRequest;
  HelpRequestDetailLoaded(this.helpRequest);
}
class HelpRequestError extends HelpRequestState {
  final String error;
  HelpRequestError(this.error);
}

class HelpRequestCubit extends Cubit<HelpRequestState> {
  final HelpRequestRepository repository;
  HelpRequestCubit(this.repository) : super(HelpRequestInitial());

  Future<void> getAll() async {
    emit(HelpRequestLoading());
    try {
      final list = await repository.getAll();
      emit(HelpRequestLoaded(list));
    } catch (e) {
      emit(HelpRequestError(e.toString()));
    }
  }

  Future<void> getById(int id) async {
    emit(HelpRequestLoading());
    try {
      final item = await repository.getById(id);
      emit(HelpRequestDetailLoaded(item));
    } catch (e) {
      emit(HelpRequestError(e.toString()));
    }
  }

  Future<void> create(HelpRequestDto dto, String token) async {
    emit(HelpRequestLoading());
    try {
      await repository.create(dto, token);
      emit(HelpRequestInitial());
    } catch (e) {
      emit(HelpRequestError(e.toString()));
    }
  }

  Future<void> update(int id, HelpRequestDto dto, String token) async {
    emit(HelpRequestLoading());
    try {
      await repository.update(id, dto, token);
      emit(HelpRequestInitial());
    } catch (e) {
      emit(HelpRequestError(e.toString()));
    }
  }

  Future<void> delete(int id, String token) async {
    emit(HelpRequestLoading());
    try {
      await repository.delete(id, token);
      emit(HelpRequestInitial());
    } catch (e) {
      emit(HelpRequestError(e.toString()));
    }
  }
} 