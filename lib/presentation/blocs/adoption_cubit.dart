import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/adoption_dto.dart';
import '../../domain/repositories/adoption_repository.dart';

abstract class AdoptionState {}
class AdoptionInitial extends AdoptionState {}
class AdoptionLoading extends AdoptionState {}
class AdoptionLoaded extends AdoptionState {
  final AdoptionDto? adoption;
  AdoptionLoaded(this.adoption);
}
class AdoptionError extends AdoptionState {
  final String error;
  AdoptionError(this.error);
}

class AdoptionCubit extends Cubit<AdoptionState> {
  final AdoptionRepository repository;
  AdoptionCubit(this.repository) : super(AdoptionInitial());

  Future<void> getByPetId(int petId) async {
    emit(AdoptionLoading());
    try {
      final adoption = await repository.getByPetId(petId);
      emit(AdoptionLoaded(adoption));
    } catch (e) {
      emit(AdoptionError(e.toString()));
    }
  }

  Future<void> create(AdoptionDto dto, String token) async {
    emit(AdoptionLoading());
    try {
      await repository.create(dto, token);
      emit(AdoptionInitial());
    } catch (e) {
      emit(AdoptionError(e.toString()));
    }
  }
} 