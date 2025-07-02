import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/help_request.dart';
import '../../data/repositories/help_request_repository_impl.dart';

// Events
abstract class HelpRequestEvent {}
class LoadHelpRequests extends HelpRequestEvent {}
class AddHelpRequest extends HelpRequestEvent {
  final HelpRequest helpRequest;
  AddHelpRequest(this.helpRequest);
}
class UpdateHelpRequest extends HelpRequestEvent {
  final int id;
  final HelpRequest helpRequest;
  UpdateHelpRequest(this.id, this.helpRequest);
}
class DeleteHelpRequest extends HelpRequestEvent {
  final int id;
  DeleteHelpRequest(this.id);
}

// States
abstract class HelpRequestState {}
class HelpRequestInitial extends HelpRequestState {}
class HelpRequestLoading extends HelpRequestState {}
class HelpRequestLoaded extends HelpRequestState {
  final List<HelpRequest> helpRequests;
  HelpRequestLoaded(this.helpRequests);
}
class HelpRequestError extends HelpRequestState {
  final String message;
  HelpRequestError(this.message);
}

// Bloc
class HelpRequestBloc extends Bloc<HelpRequestEvent, HelpRequestState> {
  final HelpRequestRepositoryImpl repository;
  HelpRequestBloc(this.repository) : super(HelpRequestInitial()) {
    on<LoadHelpRequests>((event, emit) async {
      emit(HelpRequestLoading());
      try {
        final helpRequests = await repository.getAll();
        emit(HelpRequestLoaded(helpRequests));
      } catch (e) {
        emit(HelpRequestError(e.toString()));
      }
    });
    on<AddHelpRequest>((event, emit) async {
      try {
        await repository.create(event.helpRequest);
        add(LoadHelpRequests());
      } catch (e) {
        emit(HelpRequestError(e.toString()));
      }
    });
    on<UpdateHelpRequest>((event, emit) async {
      try {
        await repository.update(event.id, event.helpRequest);
        add(LoadHelpRequests());
      } catch (e) {
        emit(HelpRequestError(e.toString()));
      }
    });
    on<DeleteHelpRequest>((event, emit) async {
      try {
        await repository.delete(event.id);
        add(LoadHelpRequests());
      } catch (e) {
        emit(HelpRequestError(e.toString()));
      }
    });
  }
} 