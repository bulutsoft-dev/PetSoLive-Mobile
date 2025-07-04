import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/adoption_request_dto.dart';
import '../../domain/repositories/adoption_request_repository.dart';

abstract class AdoptionRequestState {}
class AdoptionRequestInitial extends AdoptionRequestState {}
class AdoptionRequestLoading extends AdoptionRequestState {}
class AdoptionRequestLoaded extends AdoptionRequestState {
  final AdoptionRequestDto? request;
  AdoptionRequestLoaded(this.request);
}
class AdoptionRequestError extends AdoptionRequestState {
  final String error;
  AdoptionRequestError(this.error);
}

class AdoptionRequestCubit extends Cubit<AdoptionRequestState> {
  final AdoptionRequestRepository repository;
  AdoptionRequestCubit(this.repository) : super(AdoptionRequestInitial());

  Future<void> getById(int id) async {
    emit(AdoptionRequestLoading());
    try {
      final req = await repository.getById(id);
      emit(AdoptionRequestLoaded(req));
    } catch (e) {
      emit(AdoptionRequestError(e.toString()));
    }
  }
} 