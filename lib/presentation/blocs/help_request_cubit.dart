import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/help_request_dto.dart';
import '../../domain/repositories/help_request_repository.dart';

abstract class HelpRequestState {}
class HelpRequestInitial extends HelpRequestState {}
class HelpRequestLoading extends HelpRequestState {}
class HelpRequestLoaded extends HelpRequestState {
  final List<HelpRequestDto> helpRequests;
  final bool hasMore;
  HelpRequestLoaded(this.helpRequests, {required this.hasMore});
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
  List<HelpRequestDto> _allRequests = [];
  int _loadedCount = 0;
  final int _pageSize = 5;
  HelpRequestCubit(this.repository) : super(HelpRequestInitial());

  Future<void> getAll({bool forceRefresh = false}) async {
    if (isClosed) return;
    emit(HelpRequestLoading());
    try {
      List<HelpRequestDto> list;
      if (forceRefresh) {
        list = await repository.fetchFromApiAndSaveToLocal();
      } else {
        list = await repository.getAll();
      }
      if (isClosed) return;
      _allRequests = list;
      _loadedCount = _pageSize;
      emit(HelpRequestLoaded(_allRequests.take(_loadedCount).toList(), hasMore: _allRequests.length > _loadedCount));
    } catch (e) {
      if (isClosed) return;
      emit(HelpRequestError(e.toString()));
    }
  }

  void loadMore() {
    if (_loadedCount >= _allRequests.length) return;
    _loadedCount += _pageSize;
    emit(HelpRequestLoaded(_allRequests.take(_loadedCount).toList(), hasMore: _allRequests.length > _loadedCount));
  }

  Future<void> getById(int id) async {
    if (isClosed) return;
    emit(HelpRequestLoading());
    try {
      final item = await repository.getById(id);
      if (isClosed) return;
      emit(HelpRequestDetailLoaded(item));
    } catch (e) {
      if (isClosed) return;
      emit(HelpRequestError(e.toString()));
    }
  }

  Future<void> create(HelpRequestDto dto, String token) async {
    if (isClosed) return;
    emit(HelpRequestLoading());
    try {
      await repository.create(dto, token);
      if (isClosed) return;
      emit(HelpRequestInitial());
    } catch (e) {
      if (isClosed) return;
      emit(HelpRequestError(e.toString()));
    }
  }

  Future<void> update(int id, HelpRequestDto dto, String token) async {
    if (isClosed) return;
    emit(HelpRequestLoading());
    try {
      await repository.update(id, dto, token);
      if (isClosed) return;
      emit(HelpRequestInitial());
    } catch (e) {
      if (isClosed) return;
      emit(HelpRequestError(e.toString()));
    }
  }

  Future<void> delete(int id, String token) async {
    if (isClosed) return;
    emit(HelpRequestLoading());
    try {
      await repository.delete(id, token);
      if (isClosed) return;
      emit(HelpRequestInitial());
    } catch (e) {
      if (isClosed) return;
      emit(HelpRequestError(e.toString()));
    }
  }
} 