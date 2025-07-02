import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/adoption_request.dart';
import '../../data/repositories/adoption_request_repository_impl.dart';

// Events
abstract class AdoptionRequestEvent {}
class LoadAdoptionRequests extends AdoptionRequestEvent {}
class AddAdoptionRequest extends AdoptionRequestEvent {
  final AdoptionRequest request;
  AddAdoptionRequest(this.request);
}
class UpdateAdoptionRequest extends AdoptionRequestEvent {
  final int id;
  final AdoptionRequest request;
  UpdateAdoptionRequest(this.id, this.request);
}
class DeleteAdoptionRequest extends AdoptionRequestEvent {
  final int id;
  DeleteAdoptionRequest(this.id);
}

// States
abstract class AdoptionRequestState {}
class AdoptionRequestInitial extends AdoptionRequestState {}
class AdoptionRequestLoading extends AdoptionRequestState {}
class AdoptionRequestLoaded extends AdoptionRequestState {
  final List<AdoptionRequest> requests;
  AdoptionRequestLoaded(this.requests);
}
class AdoptionRequestError extends AdoptionRequestState {
  final String message;
  AdoptionRequestError(this.message);
}

// Bloc
class AdoptionRequestBloc extends Bloc<AdoptionRequestEvent, AdoptionRequestState> {
  final AdoptionRequestRepositoryImpl repository;
  AdoptionRequestBloc(this.repository) : super(AdoptionRequestInitial()) {
    on<LoadAdoptionRequests>((event, emit) async {
      emit(AdoptionRequestLoading());
      try {
        final requests = await repository.getAll();
        emit(AdoptionRequestLoaded(requests));
      } catch (e) {
        emit(AdoptionRequestError(e.toString()));
      }
    });
    on<AddAdoptionRequest>((event, emit) async {
      try {
        await repository.create(event.request);
        add(LoadAdoptionRequests());
      } catch (e) {
        emit(AdoptionRequestError(e.toString()));
      }
    });
    on<UpdateAdoptionRequest>((event, emit) async {
      try {
        await repository.update(event.id, event.request);
        add(LoadAdoptionRequests());
      } catch (e) {
        emit(AdoptionRequestError(e.toString()));
      }
    });
    on<DeleteAdoptionRequest>((event, emit) async {
      try {
        await repository.delete(event.id);
        add(LoadAdoptionRequests());
      } catch (e) {
        emit(AdoptionRequestError(e.toString()));
      }
    });
  }
} 